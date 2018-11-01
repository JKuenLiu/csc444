class ItemsController < ApplicationController
	def index
        @show_your_items = params[:your_items]
        if @show_your_items == 'true'
            @user_items = current_user.items
        else
            user_id = current_user.id
            @user_items = Item.where(current_holder: user_id)
        end
    end

    def show
    end

    def new
        @item = Item.new
    end

    # def edit

    # end

    def create

    end

    def update
    end

    def edit
    end

    private
    def item_params
        params.require(:item).permit(:name, :description, :start_date, :end_date, :category)
    end
end
