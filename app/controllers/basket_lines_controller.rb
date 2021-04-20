class BasketLinesController < ApplicationController
  before_action :set_farm, only: [:new, :create, :index, :update, :destroy]
  before_action :set_basket_line, only: [:update, :destroy]


  def create
    @basket = Basket.find(params[:basket_id].to_i)
    sale_id = params[:sale_id].to_i
    sale = Sale.find(sale_id)
    outlet_id = params[:pointsdevente_id].to_i
    outlet = Outlet.find(outlet_id)
    ht_unit_price = ((params[:basket_line][:ttc_unit_price].to_f  / 1.055) * 100).round
    ttc_unit_price = (params[:basket_line][:ttc_unit_price].to_f * 100).round
    ht_total = ((params[:basket_line][:ttc_total].to_f  / 1.055) * 100).round
    ttc_total = (params[:basket_line][:ttc_total].to_f * 100).round
    bed_id = params[:basket_line][:bed].to_i == 0 ? nil : params[:basket_line][:bed].to_i

    if params[:basket_line][:product].to_i == 0
      flash[:alert] = "Attention, tu n'as pas indiqué le légume"
      redirect_to farm_pointsdevente_sale_path(@farm, outlet, sale)
    end

    if params[:basket_line][:unit] == "-"
      unit = Product.find(params[:basket_line][:product]).general_unit
    else
      unit = params[:basket_line][:unit]
    end

    basket_ht_actual_total = @basket.ht_actual_total.nil? ? 0 : @basket.ht_actual_total
    basket_ttc_actual_total = @basket.ttc_actual_total.nil? ? 0 : @basket.ttc_actual_total
    ht_actual_total = basket_ht_actual_total += ht_total
    ttc_actual_total = basket_ttc_actual_total += ttc_total

    @basket_line = BasketLine.new(date: sale.date, basket_id: params[:basket_id], ht_unit_price: ht_unit_price, ttc_unit_price: ttc_unit_price, quantity: params[:basket_line][:quantity].to_f, ht_total_price: ht_total, ttc_total_price: ttc_total, unit: unit, bed_id: bed_id, product_id: params[:basket_line][:product].to_i)
    authorize @basket_line

    if @basket_line.save
      @basket.update(ttc_actual_total: ttc_actual_total, ht_actual_total: ht_actual_total)
      redirect_to farm_pointsdevente_sale_baskets_path(@farm, outlet, sale)
    end
  end

  # def new
  #   raise
  # end

  def update
    authorize @basket_line
    @basket_line.update(bed_id: params[:bed])
    if params[:source] == "basket-index"
      redirect_to farm_pointsdevente_sale_baskets_path(@farm, @basket_line.basket.sale.outlet, @basket_line.basket.sale)
    else
      redirect_to farm_pointsdevente_sale_path(@farm, @basket_line.basket.sale.outlet, @basket_line.basket.sale)
    end
  end

  def destroy
    sale = @basket_line.basket.sale
    outlet = @basket_line.basket.sale.outlet
    authorize @basket_line
    ht_total = @basket_line.ht_total_price.to_i
    ttc_total = @basket_line.ttc_total_price.to_i
    if @basket_line.destroy
      ht_actual_total = @basket_line.basket.ht_actual_total -= ht_total
      ttc_actual_total = @basket_line.basket.ttc_actual_total -= ttc_total
      @basket_line.basket.update(ttc_actual_total: ttc_actual_total, ht_actual_total: ht_actual_total)
      redirect_to farm_pointsdevente_sale_baskets_path(@farm, outlet, sale)
    end
  end

  private

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end

  def set_basket_line
    @basket_line = BasketLine.find(params[:id])
  end
end
