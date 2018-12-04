class UsersController < ApplicationController
  def update
    @user = User.find(params[:id])
    @person = Person.find_by_user_id(params[:id])

    @user.update(review_params)

    redirect_to reports_path(:person_id => @person.id)
  end

  def destroy
      @user = User.find(params[:id])
      if @user.destroy
          redirect_to root_url, notice: "User deleted."
      end
  end

  def review_params
    params.require(:user).permit(:locked)
  end
end
