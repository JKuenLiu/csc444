class HomepageController < ApplicationController
    skip_before_action :require_login
    def index
        #this is just some code to add data into for a user
        #create_dummy_data
        #create_dummy_data
        @item = Item.new
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
