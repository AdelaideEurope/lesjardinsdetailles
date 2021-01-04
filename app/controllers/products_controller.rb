class ProductsController < ApplicationController
  def index
    @products = Product.all
    authorize @products
  end

  # def show
  #   @product = Product.find(params[:id])
  #   authorize @product
  # end
end
