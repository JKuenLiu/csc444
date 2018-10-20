class PeopleController < ApplicationController
  def edit
  end

  def update
    @person = Person.find_by_user_id(current_user.id);
    @person.update(params.require(:person).permit(:fname, :lname, :addr, :phone))
    render plain: Person.find_by_user_id(current_user.id).inspect
  end
end
