class PeopleController < ApplicationController
  def edit
    @person = Person.find_by_user_id(current_user.id);
  end

  def show
    @person = Person.find_by_user_id(current_user.id);
  end
  def update
    @person = Person.find_by_user_id(current_user.id);
    @person.update(people_params)
    if !@person.avatar.attached?
      @person.avatar.attach(params[:avatar]);
    end
    redirect_to profile_path
  end
  
  private
    def people_params
      params.require(:person).permit(:fname, :lname, :addr, :phone, :avatar)
    end
end
