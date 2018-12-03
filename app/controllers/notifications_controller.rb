class NotificationsController < ApplicationController
    def index
        #puts "---------------------------entering index of notifications controller"
        @person = Person.find_by_user_id(current_user.id)
        @items = @person.items
        @pending_requests = get_pending_requests()
        @pending_returns = get_pending_returns()
        @items_approaching_due_date = items_due_within_time_period(3.days)
        @items_overdue = get_items_overdue()
    end

    def show
    end

    ##############################################
    ##############PRIVATE FUNCTIONS###############
    ##############################################
    private

end
