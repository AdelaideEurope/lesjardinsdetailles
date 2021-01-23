class FarmsController < ApplicationController
  before_action :set_farm, only: [:show]

  def show
    authorize @farm
    @clients = @farm.clients
    @workers = @farm.workers
    @outlets = @farm.outlets
  end

  def set_farm
    @farm = Farm.find(params[:id])
  end
end
