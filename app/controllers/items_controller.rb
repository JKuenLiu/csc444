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
    end

    def edit
    end

    def show
        @person = Person.find_by_user_id(current_user.id)
        @item = Item.find(params[:id])
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
        @person = Person.find_by_user_id(current_user.id)
        @item = @person.items.find(params[:id])

        # destroy transactions related to this item
        @transactions = Transaction.where(id: @items.map(&:id))
        @transactions.destroy_all

        @item.destroy
        redirect_to items_path
    end

    def request_item
        @person = Person.find_by_user_id(current_user.id)
        @item = Item.find(params[:id])

        #user must be assign a start date and end date before a request
        if !check_dates
            redirect_to @item
            return
        end
        #request successful, continue transaction
        transaction_params = {:person_id => @person.id, :item_id => params[:id], :date => DateTime.now, :status => :requested}
        @transaction = Transaction.new(transaction_params)
        if @transaction.save
            puts 'Success'
        else
            puts 'Error'
        end
        redirect_to @item
    end

    def return_item
      @person = Person.find_by_user_id(current_user.id)
      @item = Item.find(params[:id])
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

    private

    def item_params
        params.require(:item).permit(:name, :description, :start_date, :end_date, :category)
    end

    def check_dates
        start_date = params[:start_date]
        end_date   = params[:end_date]
        @item.start_date = start_date
        @item.end_date   = end_date
        if start_date != nil && end_date != nil
            @item.save
        else
            false
        end
    end
end
