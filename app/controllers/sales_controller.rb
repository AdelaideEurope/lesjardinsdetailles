class SalesController < ApplicationController
  def index
    @sales = Sale.all
    authorize @sales
  end

  def show
    @sale = Sale.find(params[:id])
    authorize @sale
  end
end
