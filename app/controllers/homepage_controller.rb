class HomepageController < ApplicationController
    skip_before_action :require_login
    before_action :require_login, only: [:notifications, :history]

    def index
        @all_items = Array.new
         if params[:term]
             @all_items = Item.where('name LIKE ?', "%#{params[:term]}%")
             Tag.where('name LIKE ?', "%#{params[:term]}%").each{|tag| @all_items += tag.items}
         else
             @all_items = Item.all
         end
         @all_items_distance = get_item_distance(@all_items)
         puts "all item distances", @all_items_distance
    end

    def history
        @person = Person.find_by_user_id(current_user.id)
        @items = @person.items
        @interactions = Interaction.where(item_id: @items.map(&:id)).order(date: :desc)
    end


    def notifications
        @person = Person.find_by_user_id(current_user.id)
        @items = @person.items
        #@interactions = Interaction.where(item_id: @items.map(&:id)).order(date: :desc)
        @item_interactions = get_pending_requests
        #@interaction = get_pending_notifications
    end

    ##############################################
    ##############PRIVATE FUNCTIONS###############
    ##############################################
    private

    def get_item_distance(all_items)
        if current_user.blank?
            return nil
        end
        item_distance  = Hash.new
        cur_person_location = Person.find_by_user_id(current_user.id)
        all_items.each do |item|
            #unique_users[item.person_id] = 1
            other_person_location = Person.find_by_user_id(item.person_id)
            distance = cur_person_location.distance_to(other_person_location, :km)
            #if you have an invalid address
            if distance.blank?
                return
            end
            item_distance[item.id] = (distance*10).ceil/10.0
        end
        return item_distance
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
