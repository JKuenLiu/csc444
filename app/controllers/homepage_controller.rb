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
        @person = Person.find_by_user_id(current_user.id)
        @items = @person.items
        @transactions = Transaction.where(item_id: @items.map(&:id)).order(date: :desc)
    end


    def notifications
        @person = Person.find_by_user_id(current_user.id)
        @items = @person.items
        @transactions = Transaction.where(item_id: @items.map(&:id)).order(date: :desc)
    end

    def approve_request
        puts "---------approve_request-----------"
        transaction_params = {:person_id => params[:person_id], :item_id => params[:item_id], :date => DateTime.now, :status => :approved}
        puts transaction_params
        @transaction = Transaction.new(transaction_params)
        if @transaction.save
            puts 'Success'
            person = transaction_params[:person_id]
            Item.where(transaction_params[:item_id]).update(current_holder: person)
        else
            puts 'Error'
        end

        redirect_to homepage_notifications_path
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
