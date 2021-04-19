class OutletsController < ApplicationController
  before_action :set_farm, only: [:new, :create, :show, :last_prices_multiple_new, :last_prices_multiple_create]
  before_action :set_outlet, only: [:show]

  def index
    @outlets = Outlet.where(farm_id: current_user.farm_id)
    authorize @outlets
  end

  def show
    authorize @outlet
    if params[:query].present?
      @query = params[:query]
      month_number = I18n.t(:month_numbers)[params[:query].to_sym]
      paid_not_paid_list = ["payé", "payée", "pay", "impayé", "impayée", "impay", "imp"]
      panier_list = ["paniers", "pan", "panier"]

      if month_number != nil
        sales_for_month(month_number)
      elsif paid_not_paid_list.include?(@query)
        paid_not_paid_sales(params[:query])
      elsif panier_list.include?(@query)
        panier_sales(params[:query])
      else
        @sales = @farm.sales.order("date DESC")
        @sale_count = @sales.length
      end
    else
      @sales = @farm.sales.order("date DESC")
      @sale_count = @sales.length
    end
  end

  def new
    @outlet = Outlet.new
    @outlet_groups = OutletGroup.all.map{ |og| [og.name, og.id]}
    authorize @outlet
  end

  def create
    @outlet = Outlet.new(id: params[:outlet][:id], full_name: params[:outlet][:full_name], shortened_name: params[:outlet][:shortened_name], address: params[:outlet][:address], zip_code: params[:outlet][:zip_code], city: params[:outlet][:city], email: params[:outlet][:email], phone_number: params[:outlet][:phone_number], has_customers: params[:outlet][:has_customers], outlet_group_id: params[:outlet][:outlet_group_id], farm_id: @farm.id, color: params[:outlet][:color], preferred_payment_method: params[:outlet][:preferred_payment_method], comment: params[:outlet][:comment], invoicing: params[:outlet][:invoicing], phone_number_owner: params[:outlet][:phone_number_owner])
    authorize @outlet
    if @outlet.save
      if params[:outlet][:picture]
        @outlet.photo.attach(params[:outlet][:picture])
      end
      flash[:notice] = "Point de vente créé avec succès !"
      redirect_to farm_path(@farm)
    else
      flash[:alert] = "Il doit manquer quelques infos"
      render :new
    end

  end

  def last_prices_multiple_new
    @outlets = Outlet.where(farm_id: current_user.farm_id)
    authorize @outlets
  end


  def last_prices_multiple_create
    @outlets = Outlet.where(farm_id: current_user.farm_id)
    authorize @outlets
    slices = params[:string].split(";").map {|sub| sub.split("/")}
  end

  private

  def sales_for_month(month)
    @sales = Sale.where('extract(month from date) = ?', month).order("date DESC")
    @sale_count = @sales.length
  end

  def paid_not_paid_sales(query)
    paid_list = ["payé", "payée", "pay",]
    not_paid_list = ["impayé", "impayée", "impay", "imp"]
    if not_paid_list.include?(query)
      @sales = Sale.all.select { |sale| !sale.is_paid? && sale.ttc_total != 0 }.sort_by(&:date).reverse!
      @sale_count = @sales.length
      @total_unpaid = @sales.map{|s| s.ttc_total}.sum
    elsif paid_list.include?(query)
      @sales = Sale.all.select { |sale| sale.is_paid? }.sort_by(&:date).reverse!
      @sale_count = @sales.length
    end
  end

  def panier_sales(query)
    @sales = Sale.all.select { |sale| sale.has_baskets? }.sort_by(&:date).reverse!
    @sale_count = @sales.length
  end

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end

  def set_outlet
    @outlet = Outlet.find(params[:id])
  end

end
