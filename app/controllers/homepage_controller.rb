class HomepageController < ApplicationController

  #Allows user to access login page without requiring to be logged in
  skip_before_action :require_login

  def index
  end
end
