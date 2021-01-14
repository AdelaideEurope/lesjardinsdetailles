class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:id])
    displayed_name
    authorize @user
  end

  private

  def displayed_name
    if @user.first_name == "Bras"
      @displayed_name = "Help"
    elsif !@user.nickname.nil?
      @displayed_name = @user.nickname
    else
      @displayed_name = @user.first_name
    end
  end
end
