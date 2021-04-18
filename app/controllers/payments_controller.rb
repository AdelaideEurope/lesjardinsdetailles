class PaymentsController < ApplicationController
  before_action :set_farm, only: [:new, :create, :index, :update, :show]
  before_action :set_outlet, only: [:new, :create, :update]
  before_action :set_payment, only: [:show, :update]

  private

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end

  def set_outlet
    @outlet = Outlet.find(params[:pointsdevente_id])
  end

  def set_payment
    @payment = Payment.find(params[:id])
  end
end
