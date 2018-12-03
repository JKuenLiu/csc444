class ItemsController < ApplicationController
	def index
        @person = Person.find_by_user_id(current_user.id)
        @show_your_items = params[:your_items]
        @interactions = nil

        if @show_your_items == 'true'
            @user_items = @person.items

        else
            @user_items = Item.where(current_holder: @person.id)

            # For all of current users borrowed items, get the most recent interaction that occurred
            # (should be the 'Approved' interaction)
            logger.debug "number of owned interactions"
            logger.debug @user_items.map(&:id)
            @interactions = Interaction.where(person_id: @person.id,
                                              item_id: @user_items.map(&:id))
                                       .order("created_at DESC")
            # @interactions = @user_items.interactions.where(person_id: @person.id)
            #                                         .order("created_at DESC")
            logger.debug "number of owned interactions"
            logger.debug @interactions.count
        end
    end

    def update
        find_item_and_person
        @item.photos.purge
        if @item.update(item_params)
            populateTagLinks
            redirect_to @item
        else
            render 'edit'
        end
    end

    def edit
        find_item_and_person
    end

    def show
        find_item_and_person
        @valid_interaction = verify_interaction
        @interaction = Interaction.new
        @item_owner  = Person.find_by_id(@item.person_id)
        @item_category = get_item_category(@item)
        @latitude, @longitude = get_item_location(@item_owner)
    end

    def new
        @item = Item.new
    end

    def create
        @person = Person.find_by_user_id(current_user.id)
        @item = @person.items.create(item_params)
        puts params[:tags]
        populateTagLinks
        if @item.errors.any?
            render 'new'
        else
            redirect_to item_path(@item)
        end
    end

    def destroy
        find_item_and_person

        # destroy interactions related to this item
        @interactions = Interaction.where(id: @item.id)
        @interactions.destroy_all

        @item.destroy
        redirect_to items_path
    end


    ##############################################
    ##############PRIVATE FUNCTIONS###############
    ##############################################
    private

    def get_item_category(category)
        if category == "1"
            return "Accessories"
        elsif category == "2"
            return "Clothing"
        elsif category == "3"
            return "Electronics"
        else
            return "None"
        end
    end

    def find_item_and_person
        @person = Person.find_by_user_id(current_user.id)
        @item = Item.find(params[:id])
    end

    def find_most_recent_approved_interaction
        interaction_with_item = Interaction.where(item_id: @item.id).order("date")
        interaction_with_item_approved = interaction_with_item.where(status: :approved)
        last_approved_interaction = interaction_with_item_approved.last
        return last_approved_interaction
    end

    def find_most_recent_return
        interaction_with_item = Interaction.where(item_id: @item.id).order("date")
        interaction_with_item_returned = interaction_with_item.where(status: :returned)
        if interaction_with_item_returned.count > 0
            last_returned_date = interaction_with_item_returned.last.date
            return last_returned_date
        else
            return nil
        end
    end

    def is_a_double_request(requested_interactions)
        #puts "requested interactions:", requested_interactions.all
        if requested_interactions.where(person_id: @person.id, status: :requested).count > 0
			return false
		else
			return true
		end
    end

    def verify_interaction
        #if it is the owner, she/he cannot request the item
        if @person.items.include?(@item)
        	return false
        else
            #in this case you are a borrower requesting an item
            #puts "number of interactions: ", Interaction.all.count, @item.id, Interaction.where(item_id: @item.id).start_date
            # Interaction.all.each do |i|
            #     puts "item_id: ", i.item_id
            # end
            interaction_with_item = Interaction.where(item_id: @item.id).order("date")
            if interaction_with_item.count > 0
                cur_item = interaction_with_item.last
                #if the item is returned, anyone can borrow the item again
                if cur_item.returned?
                    puts "-----------item is returned"
                    return true
                #no one can request an item once it has been borrowed
                elsif cur_item.approved?
                    puts "-----------item was approved"
                    return false
                #if the item is currently being requested, then you are only allowed
                #one request per time the item is out
                elsif cur_item.requested?
                    puts "-----------the item is requested"
                    last_returned_date = find_most_recent_return
                    if last_returned_date != nil
                        interactions_after_last_returned_date = interaction_with_item.where("date > ?", last_returned_date)
                        return is_a_double_request(interactions_after_last_returned_date)
                    else
                        puts "-----------not ever returned"
                        return is_a_double_request(interaction_with_item)
                    end
                #something is fucked if this happens
                else
                    puts "something is fucked!"
                    #alert
                end
            else
                puts "-----no valid interactions"
                return true
            end
        end
    end

    def item_params
        category = params[:item][:category]
        params[:item][:category] = get_item_category(category)
        params.require(:item).permit(:name, :description, :start_date, :end_date, :category, photos: [])
    end

    def populateTagLinks
      @item.tags.clear
      tagsList = params[:tags].split(",").map(&:strip) #split by commas and remove whitespaces
      tagsList.each do |item|
          curTag = Tag.find_by_name(item)
          if curTag == nil
              curTag = Tag.create(name: item)
          end
          @item.tags << curTag
      end
    end

    def get_item_location(item_owner)
        # if current_user.blank?
        #     return nil
        # end
        # cur_person = Person.find_by_id(@item.person_id)

        return item_owner.latitude, item_owner.longitude
    end
end
