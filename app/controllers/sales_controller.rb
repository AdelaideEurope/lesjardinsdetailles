class SalesController < ApplicationController
  def index
    @sales = Sale.all
    authorize @sales
  end
end
