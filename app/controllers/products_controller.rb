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

    convert_euro_params_to_cents(@product)
    if @product.update(product_params)
      flash[:notice] = "Produit modifié avec succès !"
      redirect_to farm_produits_path(current_user.farm_id)
    else
      render :edit
    end
  end

  private
  def set_product
    @product = Product.includes(:product_group, :farm).friendly.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :product_type, :general_unit, :general_price_final_client, :general_price_intermediary, :yearly_bed_count, :yield_per_sqm, :estimated_turnover, :product_group_id, :color, :spacing, :row_count, :loss_percentage, :growth_duration_in_weeks, :harvest_duration_in_weeks, :picture)
  end

  def convert_euro_params_to_cents(product)
    general_price_final_client_in_euros = params[:product][:general_price_final_client]
    general_price_intermediary_in_euros = params[:product][:general_price_intermediary]
    yield_per_sqm_in_euros = params[:product][:yield_per_sqm]

    if params[:product][:general_price_final_client] != product.general_price_final_client
      params[:product][:general_price_final_client] = general_price_final_client_in_euros.to_f * 100
    end

    if params[:product][:general_price_intermediary] != product.general_price_intermediary
      params[:product][:general_price_intermediary] = general_price_intermediary_in_euros.to_f * 100
    end

    if params[:product][:yield_per_sqm] != product.yield_per_sqm
      params[:product][:yield_per_sqm] = yield_per_sqm_in_euros.to_f * 100
    end
  end
end


