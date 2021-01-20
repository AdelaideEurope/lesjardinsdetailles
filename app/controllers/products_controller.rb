class ProductsController < ApplicationController
  def index
    if params[:query].present?
      sql_query = "name ILIKE :query"
      @products = Product.where(sql_query, query: "%#{params[:query]}%").where(farm_id: current_user.farm_id).order(:slug)
    else
      @products = Product.includes(:product_group, :photo_attachment).where(farm_id: current_user.farm_id).order(:slug)
    end
    authorize @products
  end

  # def show
  #   @product = Product.find(params[:id])
  #   authorize @product
  # end
end
