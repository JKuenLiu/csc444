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
        if user_signed_in?
            @items_due_within_time_period = count_items_due_within_time_period
            @items_due_within_time_period_string = @items_due_within_time_period.to_s
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
        transaction_params = {:person_id => params[:person_id],
                              :item_id => params[:item_id],
                              :date => DateTime.now, :status => :approved,
                              :start_date => params[:start_date],
                              :end_date => params[:end_date]}
        puts transaction_params
        @transaction = Transaction.new(transaction_params)
        if @transaction.save
            puts '-----------Approval Success'
            @item_update = Item.where(id: transaction_params[:item_id])
            @item_update.update(current_holder: transaction_params[:person_id])
        else
            puts '-----------Approval Failure'
        end

        redirect_to homepage_notifications_path
    end

    def count_items_due_within_time_period
        #return 0
        puts "-----counting overdue items------"
        @person = Person.find_by_user_id(current_user.id)
        user_items = Item.where(current_holder: @person.id)
        time_period = 3.days
        puts "-------item ids:", user_items.ids
        approved_item_transactions = []
        user_items.each do |i|
            #the most recent transaction status of the current holder has to be
            #"approved"
            last_transaction = Transaction.where(item_id: i.id).order("date").last
            approved_item_transactions.push(last_transaction)
        end
        if approved_item_transactions.count < 1
            puts "-----no overdue items:"
            return 0
        end
        puts "-----potentially overdue item"
        overdue_items = 0
        approved_item_transactions.each do |transaction|
            if transaction.end_date > Date.today + time_period
                overdue_items += 1
            end
        end
        # <% if @items_due_within_time_period > 0 %>
        #   <%= link_to 'Notifications (' + @items_due_within_time_period_string + ')',  homepage_notifications_path %> |
        # <% else %>
        #   <%= link_to 'Notifications',  homepage_notifications_path %> |
        # <% end %>

        return overdue_items
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
