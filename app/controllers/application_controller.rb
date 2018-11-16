class ApplicationController < ActionController::Base
	before_action :require_login, :num_of_notifications

	private
	def require_login
		unless current_user
			redirect_to new_user_session_path
		end
	end

	def num_of_notifications
		if user_signed_in?
			@items_due_within_time_period = count_items_due_within_time_period
			@items_due_within_time_period_string = @items_due_within_time_period.to_s
		else
			@items_due_within_time_period_string = nil
		end
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
end
