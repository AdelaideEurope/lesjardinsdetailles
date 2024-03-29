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
      ttc_price = params[:basket][:ad_hoc_ttc_price].to_i * 100
      basket_name = params[:basket][:ad_hoc_name] != "" ? params[:basket][:ad_hoc_name] : "Panier à #{params[:basket][:ad_hoc_ttc_price]} €"
      @basket = Basket.new(name: basket_name, date: date, sale_id: basket_sale_id, comment: params[:basket][:ad_hoc_comment], quantity: params[:basket][:ad_hoc_quantity], ttc_price: ttc_price, ht_price: (ttc_price / 1.055).round, recurrent: false, cumulated_difference: 0)
      authorize @basket

      if @basket.save
        flash[:notice] = "Panier à #{params[:basket][:ad_hoc_ttc_price]} € créé avec succès ! Tu peux en créer d'autres sur cette page"
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
        ttc_price = params[:basket][:ad_hoc_ttc_price].to_i * 100
        basket_name = params[:basket][:name] != "" ? params[:basket][:name] : "Panier à #{params[:basket][:ttc_price]} €"
        @basket = Basket.create(name: basket_name, date: date, sale_id: basket_sale_id, comment: params[:basket][:comment], quantity: params[:basket][:quantity], ttc_price: ttc_price, ht_price: (ttc_price / 1.055).round, recurrent: true, cumulated_difference: 0)
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
        ttc_price = params[:basket][:ad_hoc_ttc_price].to_i * 100
        @basket = Basket.create(name: basket_name, date: date, sale_id: basket_sale_id, comment: params[:basket][:comment], quantity: params[:basket][:quantity], ttc_price: ttc_price, ht_price: (ttc_price / 1.055).round, recurrent: true, cumulated_difference: 0)
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
    @previous_baskets = @outlet.baskets.where("baskets.date < ?", @sale.date).sort_by(&:date).reverse.group_by(&:ttc_price)
    to_harvest(@sale)
    @differences = Hash.new { |difference, basket_price| difference[basket_price] = "".to_i }
    @outlet.baskets.where("baskets.date <= ?", @sale.date).each do |basket|
      actual_total = basket.ttc_actual_total.nil? ? 0 : basket.ttc_actual_total
      @differences[basket.ttc_price] += (actual_total - basket.ttc_price)
    end
  end

  def update
    authorize @basket
    if params[:confirm] == "true" && @basket.confirmed != true
      if @basket.update(confirmed: true)
        basket_ht_total = @basket.sale.ht_total += @basket.ht_price * @basket.quantity
        basket_ttc_total = @basket.sale.ttc_total += @basket.ttc_price * @basket.quantity
        outlet_ht_turnover = @outlet.ht_turnover += @basket.ht_price * @basket.quantity
        outlet_ttc_turnover = @outlet.ttc_turnover += @basket.ttc_price * @basket.quantity
        farm_ht_turnover = @farm.ht_turnover += @basket.ht_price * @basket.quantity
        farm_ttc_turnover = @farm.ttc_turnover += @basket.ttc_price * @basket.quantity

        @basket.basket_lines.each do |basket_lines|
          product_ht_total = basket_lines.product.ht_turnover += (basket_lines.ht_total_price * @basket.quantity)
          product_ttc_total = basket_lines.product.ttc_turnover += (basket_lines.ttc_total_price * @basket.quantity)
          basket_lines.product.update(ht_turnover: product_ht_total, ttc_turnover: product_ttc_total)
        end
        @basket.sale.update(ht_total: basket_ht_total, ttc_total: basket_ttc_total)
        @outlet.update(ht_turnover: outlet_ht_turnover, ttc_turnover: outlet_ttc_turnover)
        @farm.update(ht_turnover: farm_ht_turnover, ttc_turnover: farm_ttc_turnover)
        redirect_to farm_pointsdevente_sale_path(@farm, @outlet.id, @basket.sale.id, @basket.id)
      end
    end
  end

  private

  def to_harvest(sale)
    @no_sale_today = true
    @basket_lines_today = BasketLine.all.select{|b| b.basket.sale.id == sale.id}
    @basket_lines_today.length != 0 ? @no_sale_today = false : true
    @to_harvest_lines = Hash.new { |to_harvest, product| to_harvest[product] = { unit: "", quantity: "".to_f, bed: [] } }
    @basket_lines_today.sort_by(&:product).each do |line|
      @to_harvest_lines[line.product.name.capitalize][:unit] = line.unit
      @to_harvest_lines[line.product.name.capitalize][:quantity] += (line.quantity * line.basket.quantity)
      @to_harvest_lines[line.product.name.capitalize][:bed].push(line.bed.full_name) if !line.bed.nil?
    end
  end

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
