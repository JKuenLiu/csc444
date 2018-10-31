class ItemController < ApplicationController
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

    def update
    end

    def edit
    end
end
