class HomepageController < ApplicationController
    skip_before_action :require_login
    def index
        @all_items = Array.new
         if params[:term]
             @all_items = Item.where('name LIKE ?', "%#{params[:term]}%")
             Tag.where('name LIKE ?', "%#{params[:term]}%").each{|tag| @all_items += tag.items}
         else
             @all_items = Item.all
         end
    end

    def history
        @person = Person.find_by_user_id(current_user.id)
        @items = @person.items
        @interactions = Interaction.where(item_id: @items.map(&:id)).order(date: :desc)
    end


    def notifications
        @person = Person.find_by_user_id(current_user.id)
        @items = @person.items
        @interactions = Interaction.where(item_id: @items.map(&:id)).order(date: :desc)
    end

    private
    #hacky function made to do some simple data entry. Be careful when you use
    #this function because it will create new entries every time you call it in
    #a specific page
    def create_dummy_data
        user = current_user
        holder = User.find_by(email: "qwer@qwer.com")
        holder_id = holder.id
        for i in 0..1
            @items = user.items.create(name: user.email + i.to_s, current_holder: holder_id)
        end
    end
end
