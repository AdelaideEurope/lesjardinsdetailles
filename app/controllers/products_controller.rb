class ProductsController < ApplicationController
  def index
    if params[:query].present?
      sql_query = "name ILIKE :query"
      @products = Product.where(sql_query, query: "%#{params[:query]}%")
    else
      @products = Product.all
    end
    authorize @products
  end

  # def show
  #   @product = Product.find(params[:id])
  #   authorize @product
  # end
end
