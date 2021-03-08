class SalesLineController < ApplicationController
  before_action :set_farm, only: [:new, :create, :index, :update]

  def create
    raise
  end


  private

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end

end
