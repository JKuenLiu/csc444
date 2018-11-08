class HomepageController < ApplicationController
    skip_before_action :require_login
    def index
        #@item = Item.new
        @all_items = if params[:term]
                     Item.where('name LIKE ?', "%#{params[:term]}%")
                 else
                     Item.all
                 end
    end

    def history

    end


    def notifications

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
