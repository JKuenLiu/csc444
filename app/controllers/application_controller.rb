class ApplicationController < ActionController::Base
	before_action :require_login, :num_of_notifications

	private
	def require_login
		unless current_user
			redirect_to new_user_session_path
		end
	end

	def num_of_notifications
        #if there is no person created yet we need to delete the user that is
        #created
        if current_user
            person = Person.find_by_user_id(current_user.id)
            if person.blank?
                current_user.destroy
                return
            end
        end
        @num_notifictions_str = nil
		if user_signed_in?
            num_notifictions = get_number_of_notifications()
            if num_notifictions > 99
                @num_notifictions = "99+"
            else
                @num_notifictions_str = num_notifictions.to_s
            end
        end
	end

    def get_number_of_notifications
        pending_requests = get_pending_requests()
        pending_returns = get_pending_returns()
        items_approaching_due_date = items_due_within_time_period(3.days)
        items_overdue = get_items_overdue()
        total_notifications = 0

        total_notifications =
            items_overdue.count +
            items_approaching_due_date.count +
            pending_returns.count

            pending_requests.each do |request|
                total_notifications += request.count
            end
        return total_notifications
    end

    def get_approved_item_interactions
        @person = Person.find_by_user_id(current_user.id)
        if current_user and @person.blank?
            #delete the current user and try again
            current_user.destroy
            redirect_to homepage_index_path
            return
        end
        user_items = Item.where(current_holder: @person.id)
        approved_item_interactions = []
        user_items.each do |i|
            #the most recent interaction status of the current holder has to be
            #"approved"
            last_interaction = Interaction.where(item_id: i.id).order("date").last
            approved_item_interactions.push(last_interaction)
        end
        return approved_item_interactions
    end

    def items_due_within_time_period(time_period)
        approved_item_interactions = get_approved_item_interactions()
	    if approved_item_interactions.count < 1
	        return []
	    end
	    remind_items = []
	    approved_item_interactions.each do |interaction|
	        if Date.today - time_period <= interaction.end_date &&
               Date.today >= interaction.end_date
	            remind_items.push(interaction)
	        end
	    end

	    return remind_items
	end

    def get_items_overdue
        approved_item_interactions = get_approved_item_interactions()
	    if approved_item_interactions.count < 1
	        return []
	    end
	    overdue_items = []
	    approved_item_interactions.each do |interaction|
	        if Date.today > interaction.end_date
	            overdue_items.push(interaction)
	        end
	    end

	    return overdue_items
    end

    def get_pending_requests
        person = Person.find_by_user_id(current_user.id)
        items = person.items
        if items.blank?
            return []
        end
        #last_approved_interactions = []
        pending_notifications      = []
        items.each do |i|
            item_interactions = Interaction.where(item_id: i.id).order("date")
            if !item_interactions.blank?
                last_approved_interaction = item_interactions.where(status: :approved).last
                last_returned_interaction = item_interactions.where(status: :returned).last
                last_available_interaction = item_interactions.where(status: :available).last

                no_interactions_for_item =
                    last_approved_interaction.blank? &&
                    last_returned_interaction.blank? &&
                    last_available_interaction.blank?

                if ( no_interactions_for_item ||
                    (!last_available_interaction.blank? &&
                     last_available_interaction.date > last_approved_interaction.date &&
                     last_available_interaction.date > last_returned_interaction.date))
                    #get all requests after returned date
                    if !last_available_interaction.blank?
                        last_returned_date = last_available_interaction.date
                        pending_notifications.push(item_interactions.where("date > ?", last_returned_date))
                    else
                        pending_notifications.push(item_interactions)
                    end
                end
            end
        end
        return pending_notifications
    end

    def get_pending_returns
        person = Person.find_by_user_id(current_user.id)
        items = person.items
        if items.blank?
            return []
        end
        pending_notifications = []
        items.each do |i|
            item_interactions = Interaction.where(item_id: i.id).order("date")
            if !item_interactions.blank? and !item_interactions.last.failed?
                last_approved_interaction = item_interactions.where(status: :approved).last
                last_returned_interaction = item_interactions.where(status: :returned).last
                last_available_interaction = item_interactions.where(status: :available).last

                item_returned = !last_returned_interaction.blank?
                item_available = !last_available_interaction.blank?

                if (item_returned &&
                    ((item_available && last_returned_interaction.date > last_available_interaction.date) ||
                     (!item_available && last_returned_interaction.date > last_approved_interaction.date)))
                    #get all requests after returned date
                    pending_notifications.push(last_returned_interaction)
                end
            end
        end
        return pending_notifications
    end
end
