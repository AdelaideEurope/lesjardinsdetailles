class ProductsController < ApplicationController
  def index
    @products = Product.all
    authorize @products
  end
end
