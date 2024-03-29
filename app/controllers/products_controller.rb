class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update]
  before_action :set_farm, only: [:index, :edit, :update, :new, :create, :product_variets_multiple_new, :product_variets_multiple_create]

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
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def edit
    authorize @product
    @product_groups = ProductGroup.all.map { |group| [group.name.capitalize, group.id] }
  end

  def new
    @product = Product.new
    authorize @product
    @product_groups = ProductGroup.all.map { |group| [group.name.capitalize, group.id] }
  end

  def create
    @product = Product.new(name: params[:product][:name].downcase, product_type: params[:product][:product_type], general_unit: params[:product][:general_unit], general_price_final_client: params[:product][:general_price_final_client], general_price_intermediary: params[:product][:general_price_intermediary], yearly_bed_count: params[:product][:yearly_bed_count], yield_per_sqm: params[:product][:yield_per_sqm], estimated_turnover: params[:product][:estimated_turnover], product_group_id: params[:product][:product_group_id], color: params[:product][:color], spacing: params[:product][:spacing], row_count: params[:product][:row_count], loss_percentage: params[:product][:loss_percentage], growth_duration_in_weeks: params[:product][:growth_duration_in_weeks], harvest_duration_in_weeks: params[:product][:harvest_duration_in_weeks], farm_id: params[:farm_id])
    authorize @product
    @product.save
    @product.photo.attach(params[:product][:picture]) if params[:product][:picture]
    @fertilization_need = FertilizationNeed.new(fertilization_type: params[:ferti][:type], unit: params[:ferti][:unit], quantity: params[:ferti][:quantity], product_id: @product&.id)
      if @fertilization_need.save
      flash[:notice] = "Produit créé avec succès !"
      redirect_to farm_produits_path(@farm)
      else
        flash[:alert] = "Il doit manquer quelques infos"
        render :new
      end
  end


  def update
    authorize @product
    convert_euro_params_to_cents(@product)
    if @product.update(product_params)
      if params[:product][:picture]
        @product.photo.attach(params[:product][:picture])
      end
      if @product.has_ferti_instance?
        @fertilization_need = @product.fertilization_need
        @fertilization_need.update(fertilization_type: params[:ferti][:type], unit: params[:ferti][:unit], quantity: params[:ferti][:quantity], product_id: @product.id)
        flash[:notice] = "Produit modifié avec succès !"
        redirect_to farm_produits_path(@farm)
      elsif !params[:ferti][:type].nil? && !params[:ferti][:unit].nil? && !params[:ferti][:quantity].nil?
        FertilizationNeed.create(fertilization_type: params[:ferti][:type], unit: params[:ferti][:unit], quantity: params[:ferti][:quantity], product_id: @product.id)
        flash[:notice] = "Produit modifié avec succès !"
        redirect_to farm_produits_path(@farm)
      else
        flash[:notice] = "Produit modifié avec succès !"
        redirect_to farm_produits_path(@farm)
      end

    else
      render :edit
    end
  end

  def product_variets_multiple_new
    @products = Product.all
    authorize @products
  end

  def product_variets_multiple_create
    @products = Product.all
    authorize @products
    slices = params[:string].split(";").map {|sub| sub.split("/")}
    created = 0
    slices.each do |variet|
      product_id = Product.where(name: variet[3], farm_id: variet[0])[0]&.id
      if !product_id.nil?
        if VegetableVariet.create!(product_id: product_id, name: variet[1], details: variet[2])
          created += 1
        end
      end
    end
    redirect_to farm_product_variets_multiple_new_path
    flash[:notice] = "#{created} #{created > 1 ? "variétés ajoutées" : "variété ajoutée"}... Boom !"
  end

  private
  def set_product
    @product = Product.includes(:product_group, :farm).friendly.find(params[:id])
  end

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end


  def product_params
    params.require(:product).permit(:name, :product_type, :general_unit, :general_price_final_client, :general_price_intermediary, :yearly_bed_count, :yield_per_sqm, :estimated_turnover, :product_group_id, :color, :spacing, :row_count, :loss_percentage, :growth_duration_in_weeks, :harvest_duration_in_weeks)
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


