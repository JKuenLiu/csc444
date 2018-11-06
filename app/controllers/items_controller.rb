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
        @item = Item.find(params[:id])
    end

    def new
        @item = Item.new
    end

    # def edit

    # end

    def create
        @person = Person.find_by_user_id(current_user.id)
        @item = @person.items.create(item_params)
        redirect_to item_path(@item)
    end

    def destroy
        @person = Person.find_by_user_id(current_user.id)
        @item = @person.items.find(params[:id])
        @item.destroy
        redirect_to items_path
    end

    private
    def item_params
        params.require(:item).permit(:name, :description, :start_date, :end_date, :category)
    end
end