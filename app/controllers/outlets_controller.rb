class OutletsController < ApplicationController
  before_action :set_farm, only: [:new, :create]
  before_action :set_outlet, only: [:show]

  def index
    @outlets = Outlet.where(farm_id: current_user.farm_id)
    authorize @outlets
  end

  def show
    authorize @outlet
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

  private

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end

  def set_outlet
    @outlet = Outlet.find(params[:id])
  end

end
