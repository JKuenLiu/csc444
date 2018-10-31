class PeopleController < ApplicationController
  def edit
    @person = Person.find_by_user_id(current_user.id);
  end

  def show
    @person = Person.find_by_user_id(current_user.id);
    add_default_image
  end

  def update
    @person = Person.find_by_user_id(current_user.id);
    @person.update(people_params)
    redirect_to profile_path
  end

  private
    def people_params
      params.require(:person).permit(:fname, :lname, :addr, :phone, :avatar)
    end

    def add_default_image
      if !@person.avatar.attached?
        @person.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default_avatar.jpg')), filename: 'default_avatar.jpg', content_type: 'image/jpg')
      end
    end
end
