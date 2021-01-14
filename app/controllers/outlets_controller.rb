class OutletsController < ApplicationController
  def index
    @outlets = Outlet.where(farm_id: current_user.farm_id)
    authorize @outlets
  end

  def show
    @outlet = Outlet.find(params[:id])
    authorize @outlet
  end
end
