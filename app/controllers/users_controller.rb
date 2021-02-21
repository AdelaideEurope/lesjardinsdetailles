class UsersController < ApplicationController
  before_action :set_farm, only: [:show]

  def show
    @user = User.friendly.find(params[:id])
    @workers = @farm.workers
    authorize @user
  end

  private
  def set_farm
    @farm = Farm.find(params[:farm_id])
  end
end
