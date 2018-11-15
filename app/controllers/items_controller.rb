class ItemsController < ApplicationController
	def index
        @person = Person.find_by_user_id(current_user.id)
        @show_your_items = params[:your_items]
        if @show_your_items == 'true'
            @user_items = @person.items
        else
            user_id = current_user.id
            @user_items = Item.where(current_holder: @person.id)
        end
    end
    def update
        find_item
        if validate_dates
            request_item
        else
            #verify_transaction
            redirect_to @item
        end
    end

    def edit
    end

    def show
        find_item
        verify_transaction
    end

    def new
        @item = Item.new
    end

    def create
        @person = Person.find_by_user_id(current_user.id)
        @item = @person.items.create(item_params)
        if @item.errors.any?
            render 'new'
        else
            redirect_to item_path(@item)
        end
    end

    def destroy
        find_item

        # destroy transactions related to this item
        @transactions = Transaction.where(id: @items.map(&:id))
        @transactions.destroy_all

        @item.destroy
        redirect_to items_path
    end

    def request_item
        find_item
        transaction_params = {:person_id => @person.id, :item_id => params[:id], :date => DateTime.now, :status => :requested}
        @transaction = Transaction.new(transaction_params)
        if @transaction.save
            #puts '-----Success', @transaction.person_id, @transaction.item_id, @transaction.status
            puts 'Successful Request!'
        else
            puts 'Request failed!'
        end
        redirect_to @item
    end

    def return_item
      find_item
      # TODO: Verify here that the items state is borrowed, and current user is the one that has it borrowed
      transaction_params = {:person_id => @person.id, :item_id => params[:id], :date => DateTime.now, :status => :returned}
      @transaction = Transaction.new(transaction_params)

      if @transaction.save
        puts 'Success'
      else
        puts 'Error'
      end

      redirect_to @item
    end


    ##############################################
    ##############PRIVATE FUNCTIONS###############
    ##############################################
    private

    def find_item
        @person = Person.find_by_user_id(current_user.id)
        @item = Item.find(params[:id])
    end

    def validate_dates
        start_date = params[:item][:start_date]
        end_date = params[:item][:end_date]
        if !start_date.blank? && !end_date.blank?
            @item.update(start_date: start_date)
            @item.update(end_date: end_date)
        return @item.save
        end
        if start_date.blank?
            @item.errors[:start_date] << "has no date"
        end
        if end_date.blank?
            @item.errors[:end_date] << "has no date"
        end
        #puts "--------------failed date"
        return false
    end

    def get_cur_item
        transaction_with_item = Transaction.where(item_id: @item.id).order("date")
        last_transation_of_item = transaction_with_item.last.date
        return last_transation_of_item
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
        @valid_transaction = true
        #if it is the owner, she/he cannot request the item
        if @person.items.include?(@item)
        	@valid_transaction = false
        else
            #in this case you are a borrower requesting an item
            transaction_with_item = Transaction.where(item_id: @item.id).order("date")
            if transaction_with_item.count > 0
                cur_item = transaction_with_item.last
                #if the item is returned, anyone can borrow the item again
                if cur_item.returned?
                    puts "-----------item is returned"
                    @valid_transaction = true
                #no one can request an item once it has been borrowed
                elsif cur_item.approved?
                    puts "-----------item was approved"
                    @valid_transaction = false
                #if the item is currently being requested, then you are only allowed
                #one request per time the item is out
                elsif cur_item.requested?
                    puts "-----------the item is requested"
                    last_returned_date = find_most_recent_return
                    if last_returned_date != nil
                        transactions_after_last_returned_date = transaction_with_item.where("date > ?", last_returned_date)
                        @valid_transaction = is_a_double_request(transactions_after_last_returned_date)
                    else
                        @valid_transaction = is_a_double_request(transaction_with_item)
                    end
                #something is fucked if this happens
                else
                    puts "something is fucked!"
                    alert
                end
            else
                puts "-----no valid transactions"
                @valid_transaction = true
            end
        	# transaction_with_item = Transaction.where(item_id: @item.id).order("date")
        	# if transaction_with_item.count > 0
        	# 	#check if you have already requested this item
        	# 	transaction_with_item_returned = transaction_with_item.where(status: :returned)
        	# 	if transaction_with_item_returned.count > 0
        	# 		last_returned_date = transaction_with_item_returned.last.date
        	# 		transactions_after_last_returned_date = transaction_with_item.where("date > ?", last_returned_date)
        	# 		if transactions_after_last_returned_date.where(person_id: @person.id, status: :requested).count > 0
        	# 			@valid_transaction = false
        	# 		else
        	# 			@valid_transaction = true
        	# 		end
        	# 	else
        	# 		if transaction_with_item.where(person_id: @person.id, status: :requested).count > 0
        	# 			@valid_transaction = false
        	# 		else
        	# 			@valid_transaction = true
        	# 		end
        	# 	end
        	# else
        	# 	@valid_transaction = true
        	# end
        end
    end

    def item_params
        params.require(:item).permit(:name, :description, :start_date, :end_date, :category)
    end
end
