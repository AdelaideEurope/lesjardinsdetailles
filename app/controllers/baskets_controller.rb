class BasketsController < ApplicationController
  before_action :set_farm, only: [:new, :create, :index, :update, :show]
  before_action :set_outlet, only: [:new, :create, :index, :update]
  before_action :set_basket, only: [:show, :update]

  def new
    @basket = Basket.new
    authorize @basket
  end

  def create
    if params[:basket][:frequency] == ""
      date = DateTime.parse(params[:basket][:date])
      if @outlet.sales.map{|s| s.date}.include?(date)
        basket_sale_id = @outlet.sales.where(date: date)[0].id
      else
        basket_sale_id = Sale.create(date: date, outlet_id: @outlet.id, ht_total: 0, ttc_total: 0, rounded_ht_total: 0, rounded_ttc_total: 0).id
      end
      raise
      basket_name = params[:basket][:name] != "" ? params[:basket][:name] : "Panier à #{params[:basket][:ttc_price]} €"
      @basket = Basket.new(name: basket_name, date: date, sale_id: basket_sale_id, comment: params[:basket][:comment], quantity: params[:basket][:quantity], ttc_price: params[:basket][:ttc_price].to_i * 100, ht_price: (params[:basket][:ttc_price].to_i * 100) / 1.055, recurrent: false, cumulated_difference: 0)
      authorize @basket
      if @basket.save
        flash[:notice] = "Panier à #{params[:basket][:ttc_price]} € créé avec succès ! Tu peux en créer d'autres sur cette page"
        redirect_to new_farm_pointsdevente_basket_path(@farm, @outlet)
      else
        render :new
      end

    elsif params[:basket][:frequency] == "Toutes les semaines"
      dates = [params[:basket][:first_date].to_date]
      last_added_date = params[:basket][:first_date].to_date
      last_date = params[:basket][:last_date].to_date
      while last_added_date < last_date
        new_date = last_added_date + 1.week
        last_added_date = new_date
        if new_date < last_date
          dates.push(new_date)
        end
      end
      baskets_added = 0
      dates.each do |date|
        if @outlet.sales.map{|s| s.date}.include?(date)
          basket_sale_id = @outlet.sales.where(date: date)[0].id
        else
          basket_sale_id = Sale.create(date: date, outlet_id: @outlet.id, ht_total: 0, ttc_total: 0, rounded_ht_total: 0, rounded_ttc_total: 0).id
        end
        basket_name = params[:basket][:name] != "" ? params[:basket][:name] : "Panier à #{params[:basket][:ttc_price]} €"
        @basket = Basket.create(name: basket_name, date: date, sale_id: basket_sale_id, comment: params[:basket][:comment], quantity: params[:basket][:quantity], ttc_price: params[:basket][:ttc_price].to_i * 100, ht_price: (params[:basket][:ttc_price].to_i * 100) / 1.055, recurrent: false, cumulated_difference: 0)
        authorize @basket
        baskets_added += 1
      end
      redirect_to new_farm_pointsdevente_basket_path(@farm, @outlet)
      flash[:notice] = "#{baskets_added} paniers créés avec succès !"

    elsif params[:basket][:frequency] == "Une semaine sur deux"
      dates = [params[:basket][:first_date].to_date]
      last_added_date = params[:basket][:first_date].to_date
      last_date = params[:basket][:last_date].to_date
      while last_added_date < last_date
        new_date = last_added_date + 2.week
        last_added_date = new_date
        if new_date < last_date
          dates.push(new_date)
        end
      end
      baskets_added = 0
      dates.each do |date|
        if @outlet.sales.map{|s| s.date}.include?(date)
          basket_sale_id = @outlet.sales.where(date: date)[0].id
        else
          basket_sale_id = Sale.create(date: date, outlet_id: @outlet.id, ht_total: 0, ttc_total: 0, rounded_ht_total: 0, rounded_ttc_total: 0).id
        end
        basket_name = params[:basket][:name] != "" ? params[:basket][:name] : "Panier à #{params[:basket][:ttc_price]} €"
        @basket = Basket.create(name: basket_name, date: date, sale_id: basket_sale_id, comment: params[:basket][:comment], quantity: params[:basket][:quantity], ttc_price: params[:basket][:ttc_price].to_i * 100, ht_price: (params[:basket][:ttc_price].to_i * 100) / 1.055, recurrent: false, cumulated_difference: 0)
        authorize @basket
        baskets_added += 1
      end
      redirect_to new_farm_pointsdevente_basket_path(@farm, @outlet)
      flash[:notice] = "#{baskets_added} paniers créés avec succès !"

    end
    authorize @basket
  end

  def index
    @sale = Sale.find(params[:sale_id])
    @baskets = @sale.baskets.order("ttc_price DESC")
    @colors = ["green", "orange", "red"]
    authorize @baskets
    @products = Product.where(farm_id: @farm.id).order(:slug).map { |product| [product.name.capitalize, product.id] }
    @beds = Bed.all.map { |bed| [bed.full_name, bed.id] }
    @beds.unshift(["-"])
    @new_basket_line = BasketLine.new

# # À REVOIR
#     sales = @outlet.sales.order("date ASC")[0..3]
#     prices = @sale.baskets.map { |basket| basket.ttc_price }
#     @previous_baskets = {}
#     prices.each do |price|
#       sales.each do |sale|
#         @previous_baskets[price] = sale.baskets.where(ttc_price: price)
#       end
#     end
#     return @previous_baskets
  end

  def update
    authorize @basket
    if params[:confirm] == "true" && @basket.confirmed != true
      if @basket.update(confirmed: true)
        sale_ht_total = @basket.sale.ht_total += @basket.ht_price
        sale_ttc_total = @basket.sale.ttc_total += @basket.ttc_price
        outlet_ht_turnover = @outlet.ht_turnover += @basket.ht_price
        outlet_ttc_turnover = @outlet.ttc_turnover += @basket.ttc_price
        farm_ht_turnover = @farm.ht_turnover += @basket.ht_price
        farm_ttc_turnover = @farm.ttc_turnover += @basket.ttc_price

        @basket.sale.update(ht_total: sale_ht_total, ttc_total: sale_ttc_total)
        @outlet.update(ht_turnover: outlet_ht_turnover, ttc_turnover: outlet_ttc_turnover)
        @farm.update(ht_turnover: farm_ht_turnover, ttc_turnover: farm_ttc_turnover)
        redirect_to farm_pointsdevente_sale_path(@farm, @outlet.id, @basket.sale.id, @basket.id)
      end
    end
  end

  private

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end

  def set_outlet
    @outlet = Outlet.find(params[:pointsdevente_id])
  end
  def set_basket
    @basket = Basket.find(params[:id])
  end

end
