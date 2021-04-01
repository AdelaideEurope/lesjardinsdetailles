class SalesController < ApplicationController
  before_action :set_farm, only: [:new, :create, :index, :update, :show]
  before_action :set_outlet, only: [:new, :create]
  before_action :set_sale, only: [:show, :update]

  def index
    @sales = Sale.all.order("date DESC")
    authorize @sales
    @outlets = Outlet.all
  end

  def show
    @sale = Sale.find(params[:id])
    authorize @sale
    @new_sales_line = SalesLine.new
    @sales_lines = @sale.sales_lines
    @beds = Bed.all.map { |bed| [bed.full_name, bed.id] }
    @beds.unshift(["-"])
    @products = Product.where(farm_id: @farm.id).order(:slug).map { |product| [product.name.capitalize, product.id] }
  end

  def new
    @sale = Sale.new
    authorize @sale
  end

  def create
    date = params[:sale][:date]
    if params[:sale][:frequency] == ""
      @sale = Sale.new(date: date, outlet_id: @outlet.id, comment: params[:sale][:comment])
      authorize @sale
      if @sale.save
        flash[:notice] = "Vente du #{date.to_date.strftime('%-d')} #{I18n.t(:month_names)[date.to_date.strftime('%b').to_sym]} créée avec succès !"
        redirect_to farm_ventes_path(@farm)
      else
        flash[:alert] = "Il doit manquer quelques infos"
        render :new
      end
    elsif params[:sale][:frequency] == "Toutes les semaines"
      dates = [params[:sale][:first_date].to_date]
      last_added_date = params[:sale][:first_date].to_date
      last_date = params[:sale][:last_date].to_date
      while last_added_date < last_date
        new_date = last_added_date + 1.week
        last_added_date = new_date
        dates.push(new_date)
      end
      sales_added = 0
      dates.each do |date|
        @sale = Sale.create!(date: date, outlet_id: @outlet.id, comment: params[:sale][:comment])
        authorize @sale
        sales_added += 1
      end
      redirect_to farm_ventes_path(@farm)
      flash[:notice] = "#{sales_added} ventes créées avec succès !"
    elsif params[:sale][:frequency] == "Une semaine sur deux"
      dates = [params[:sale][:first_date].to_date]
      last_added_date = params[:sale][:first_date].to_date
      last_date = params[:sale][:last_date].to_date
      while last_added_date < last_date
        new_date = last_added_date + 2.week
        last_added_date = new_date
        if new_date < last_date
          dates.push(new_date)
        end
      end
      sales_added = 0
      dates.each do |date|
        @sale = Sale.create!(date: date, outlet_id: @outlet.id, comment: params[:sale][:comment])
        authorize @sale
        sales_added += 1
      end
      redirect_to farm_ventes_path(@farm)
      flash[:notice] = "#{sales_added} ventes créées avec succès !"
    end
    authorize @sale
  end

  def update
    if params[:add_comment]
      if @sale.update(comment: params[:sale][:comment])
        redirect_to farm_ventes_path(@farm)
        flash[:notice] = "Commentaire ajouté avec succès !"
      end
    end
    authorize @sale
  end


  private

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end

  def set_outlet
    @outlet = Outlet.find(params[:pointsdevente_id])
  end
  def set_sale
    @sale = Sale.find(params[:id])
  end

end
