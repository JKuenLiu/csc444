class NotificationsController < ApplicationController
    def index
        #puts "---------------------------entering index of notifications controller" 
        @person = Person.find_by_user_id(current_user.id)
        @items  = @person.items
        @approved_item_interactions = get_pending_requests()
        @items_approaching_due_date = items_due_within_time_period(3.days)
        @items_overdue              = items_overdue()
    end

    def show
    end

    ##############################################
    ##############PRIVATE FUNCTIONS###############
    ##############################################
    private

    def get_approved_item_interactions
        puts "-----counting overdue items------"
        @person = Person.find_by_user_id(current_user.id)
        if current_user and @person.blank?
            #delete the current user and try again
            current_user.destroy
            redirect_to homepage_index_path
            return
        end
        user_items = Item.where(current_holder: @person.id)
        puts "-------item ids:", user_items.ids
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
	        puts "-----no overdue items:"
	        return 0
	    end
	    puts "-----potentially overdue item"
	    remind_items = []
	    approved_item_interactions.each do |interaction|
	        if Date.today - time_period <= interaction.end_date &&
               Date.today >= interaction.end_date
	            remind_items.push(interaction)
	        end
	    end

	    return remind_items
	end

    def items_overdue
        approved_item_interactions = get_approved_item_interactions()
	    if approved_item_interactions.count < 1
	        puts "-----no overdue items:"
	        return 0
	    end
	    puts "-----potentially overdue item"
	    overdue_items = []
	    approved_item_interactions.each do |interaction|
	        if Date.today < interaction.end_date
	            overdue_items.push(interaction)
	        end
	    end

	    return overdue_items
    end

    def get_pending_requests
        if @items.blank?
            return nil
        end
        #last_approved_interactions = []
        pending_notifications      = []
        @items.each do |i|
            item_interactions = Interaction.where(item_id: i.id).order("date")
            if !item_interactions.blank?
                last_approved_interaction = item_interactions.where(status: :approved).last
                last_returned_interaction = item_interactions.where(status: :returned).last

                if (last_approved_interaction.blank? && last_returned_interaction.blank?) ||
                   (!last_returned_interaction.blank? &&
                    last_returned_interaction.date > last_approved_interaction.date)
                    #get all requests after returned date
                    if !last_returned_interaction.blank?
                        last_returned_date = last_returned_interaction.date
                        pending_notifications.push(item_interactions.where("date > ?", last_returned_date))
                    else
                        pending_notifications.push(item_interactions)
                    end
                end
            end
        end
        return pending_notifications
    end
end
