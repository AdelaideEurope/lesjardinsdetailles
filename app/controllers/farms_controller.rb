class FarmsController < ApplicationController
  before_action :set_farm, only: [:show]

  def show
    authorize @farm
    @clients = @farm.users.where.not(worker: true).map{ |client| client }
    @workers = @farm.users.where(worker: true).map{ |client| client }
  end

  def set_farm
    @farm = Farm.find(params[:id])
  end
end
