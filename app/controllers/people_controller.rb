class PeopleController < ApplicationController
  skip_before_action :require_login, :num_of_notifications

  def new
      @person = Person.new
  end

  def create
      @person = Person.new(people_params)
      @person.user_id = current_user.id
      if @person.save
          redirect_to homepage_index_path
      else
          render 'new'
      end
  end

  def edit
    @person = Person.find_by_user_id(current_user.id);
  end

  def show
    @person = Person.find_by_id(params[:id]);
    @is_current_user = true
    if current_user.id != Person.find_by_id(params[:id]).user_id
        @is_current_user = false
    end
    add_default_image
  end

  def update
    @person = Person.find_by_user_id(current_user.id);
    @person.update(people_params)
    redirect_to person_path
  end

  private
    def people_params
      params.require(:person).permit(:fname, :lname, :street, :city, :province,
                                     :country, :phone, :avatar)
    end

    def add_default_image
      if !@person.avatar.attached?
        @person.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default_avatar.jpg')), filename: 'default_avatar.jpg', content_type: 'image/jpg')
      end
    end
end
