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
        @item.destroy
        redirect_to items_path
    end

    def request_item
        puts '-----------------------REQUEST CALLED-----------------------'
        @person = Person.find_by_user_id(current_user.id)
        transaction_params = {:person_id => @person.id, :item_id => params[:id], :date => DateTime.now, :status => :requested}
        @transaction = Transaction.new(transaction_params)
        if @transaction.save
            puts 'Success'
        else
            puts 'Error'
        end
    end

    private
    def item_params
        params.require(:item).permit(:name, :description, :start_date, :end_date, :category)
    end
end
