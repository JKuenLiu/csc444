class PeopleController < ApplicationController
  def edit
    @person = Person.find_by_user_id(current_user.id);
  end

  def show
    @person = Person.find_by_user_id(current_user.id);
  end
  def update
    @person = Person.find_by_user_id(current_user.id);
    @person.update(params.require(:person).permit(:fname, :lname, :addr, :phone))
    redirect_to profile_path
  end
end
