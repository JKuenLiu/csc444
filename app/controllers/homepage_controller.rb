class HomepageController < ApplicationController

  #Allows user to access login page without requiring to be logged in
  skip_before_action :require_login

  def index
    if user_signed_in?
      redirect_to :controller => 'user_homepage', :action => 'index'
    end
  end
end
