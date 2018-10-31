class HomepageController < ApplicationController

  #Allows user to access login page without requiring to be logged in
  skip_before_action :require_login

  def index
      #this is just some code to add data into for a user
      
  end
end
