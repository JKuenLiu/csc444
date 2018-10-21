class HomepageController < ApplicationController
  def index
    if user_signed_in?
      redirect_to :controller => 'user_homepage', :action => 'index'
    end
  end
end
