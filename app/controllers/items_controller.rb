class ItemsController < ApplicationController
	def index
        @person = Person.find_by_user_id(current_user.id)
        @show_your_items = params[:your_items]
        @transactions = nil

        if @show_your_items == 'true'
            @user_items = @person.items

        else
            @user_items = Item.where(current_holder: @person.id)

            # For all of current users borrowed items, get the most recent transaction that occurred
            # (should be the 'Approved' transaction)
            @transactions = Transaction.where(person_id: @person.id, item_id: @user_items.map(&:id))
                                        .order("created_at DESC")
        end
  end

    def update
        find_item_and_person
        request_item
    end

    def edit
    end

    def show
        find_item_and_person
        @valid_transaction = verify_transaction
        @transaction = Transaction.new
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

        # destroy transactions related to this item
        @transactions = Transaction.where(id: @item.id)
        @transactions.destroy_all

        @item.destroy
        redirect_to items_path
    end

    def request_item
        puts "-----------Requesting Item"
        find_item_and_person
        start_date = params[:item][:start_date]
        end_date = params[:item][:end_date]
        #TODO: error message when it fails
        transaction_params = {:person_id => @person.id, :item_id => params[:id],
                              :date => DateTime.now, :status => :requested,
                              :start_date => start_date, :end_date => end_date}
        @transaction = Transaction.new(transaction_params)
        if @transaction.save
            #puts '-----Success', @transaction.person_id, @transaction.item_id, @transaction.status
            puts '------------Successful Request!'
        else
            puts '------------Request failed!'
            @valid_transaction = verify_transaction
            render "show"
            return
        end
        redirect_to @item
    end

    def return_item
      find_item_and_person
      # TODO: Verify here that the items state is borrowed, and current user is the one that has it borrowed
      approved_transaction = find_most_recent_approved_transaction
      start_date = approved_transaction.start_date
      end_date = approved_transaction.end_date
      transaction_params = {:person_id => @person.id, :item_id => params[:id],
                            :date => DateTime.now, :status => :returned,
                            :start_date => start_date, :end_date => end_date}
      @transaction = Transaction.new(transaction_params)

      if @transaction.save
        puts '------------Successful return'
        @item.update(current_holder: "")
      else
        puts '------------Return failed'
      end

      redirect_to @item
    end


    ##############################################
    ##############PRIVATE FUNCTIONS###############
    ##############################################
    private


    def find_item_and_person
        @person = Person.find_by_user_id(current_user.id)
        @item = Item.find(params[:id])
    end

    def find_most_recent_approved_transaction
        transaction_with_item = Transaction.where(item_id: @item.id).order("date")
        transaction_with_item_approved = transaction_with_item.where(status: :approved)
        last_approved_transaction = transaction_with_item_approved.last
        return last_approved_transaction
    end

    def find_most_recent_return
        transaction_with_item = Transaction.where(item_id: @item.id).order("date")
        transaction_with_item_returned = transaction_with_item.where(status: :returned)
        if transaction_with_item_returned.count > 0
            last_returned_date = transaction_with_item_returned.last.date
            return last_returned_date
        else
            return nil
        end
    end

    def is_a_double_request(requested_transactions)
        if requested_transactions.where(person_id: @person.id, status: :requested).count > 0
			return false
		else
			return true
		end
    end

    def verify_transaction
        #if it is the owner, she/he cannot request the item
        if @person.items.include?(@item)
        	return false
        else
            #in this case you are a borrower requesting an item
            transaction_with_item = Transaction.where(item_id: @item.id).order("date")
            if transaction_with_item.count > 0
                cur_item = transaction_with_item.last
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
                        transactions_after_last_returned_date = transaction_with_item.where("date > ?", last_returned_date)
                        return is_a_double_request(transactions_after_last_returned_date)
                    else
                        return is_a_double_request(transaction_with_item)
                    end
                #something is fucked if this happens
                else
                    puts "something is fucked!"
                    #alert
                end
            else
                puts "-----no valid transactions"
                return true
            end
        end
    end

    def item_params
        params.require(:item).permit(:name, :description, :start_date, :end_date, :category, photos: [])
    end

  def populateTagLinks
      tagsList = params[:tags].split(",").map(&:strip) #split by commas and remove whitespaces
      tagsList.each do |item|
          curTag = Tag.find_by_name(item)
          if curTag == nil
              curTag = Tag.create(name: item)
          end
          @item.tags << curTag
      end
  end
end
