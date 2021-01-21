class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update]

  def index
    if !params[:query] && !params[:sort]
      @products = Product.includes(:product_group, :photo_attachment).where(farm_id: current_user.farm_id).order(:slug)
    elsif params[:query].present?
      sql_query = "name ILIKE :query"
      @products = Product.where(sql_query, query: "%#{params[:query]}%").where(farm_id: current_user.farm_id).order(:slug)
    elsif params[:sort] != "product_group"
      @products = Product.includes(:product_group, :photo_attachment).where(farm_id: current_user.farm_id).order(params[:sort])
    else
      @products = Product.includes(:product_group, :photo_attachment).where(farm_id: current_user.farm_id).order("product_groups.name")
    end
    authorize @products
  end

  def edit
    authorize @product
    @farm = @product.farm
    @product_groups = ProductGroup.all.map { |group| group.name.capitalize }
  end

  def update
    authorize @product
    if @product.update(product_params)
      flash[:notice] = "Produit modifié avec succès !"
      redirect_to farm_produits_path(current_user.farm_id)
    else
      render :edit
    end
  end

  private
  def set_product
    @product = Product.friendly.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :product_type, :general_unit, :general_price_final_client, :general_price_intermediary, :yearly_bed_count, :yield_per_sqm, :estimated_turnover, :product_group_id, :color, :spacing, :row_count, :loss_percentage, :growth_duration_in_weeks, :harvest_duration_in_weeks, :picture)
  end
end


