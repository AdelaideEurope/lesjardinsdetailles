class SalesLinesController < ApplicationController
  before_action :set_farm, only: [:new, :create, :index, :update, :destroy]
  before_action :set_sales_line, only: [:update, :destroy]

  def create
    sale_id = params[:sale].to_i
    sale = Sale.find(sale_id)
    outlet_id = params[:outlet].to_i
    outlet = Outlet.find(outlet_id)
    ht_unit_price = (params[:sales_line][:ht_unit_price].to_f * 100).round
    ttc_unit_price = (params[:sales_line][:ttc_unit_price].to_f * 100).round
    ht_total = (params[:sales_line][:ht_total].to_f * 100).round
    ttc_total = (params[:sales_line][:ttc_total].to_f * 100).round
    bed_id = params[:sales_line][:bed].to_i == 0 ? nil : params[:sales_line][:bed].to_i
    if params[:sales_line][:product].to_i == 0
      flash[:alert] = "Attention, tu n'as pas indiqué le légume"
      redirect_to farm_pointsdevente_sale_path(@farm, outlet, sale)
    end
    if params[:sales_line][:unit] == "-"
      flash[:alert] = "Attention, tu n'as pas indiqué l'unité"
      redirect_to farm_pointsdevente_sale_path(@farm, outlet, sale)
    end
    @sales_line = SalesLine.new(product_id: params[:sales_line][:product].to_i, bed_id: bed_id, unit: params[:sales_line][:unit], ht_unit_price: ht_unit_price, ttc_unit_price: ttc_unit_price, ht_total: ht_total, ttc_total: ttc_total, quantity: params[:sales_line][:quantity].to_f, sale_id: sale_id, date: sale.date)
    authorize @sales_line
    if @sales_line.save
      sale_ht_total = sale.ht_total += ht_total
      sale_ttc_total = sale.ttc_total += ttc_total
      outlet_ht_turnover = outlet.ht_turnover += ht_total
      outlet_ttc_turnover = outlet.ttc_turnover += ttc_total
      farm_ht_turnover = @farm.ht_turnover += ht_total
      farm_ttc_turnover = @farm.ttc_turnover += ttc_total
      sale.update(ht_total: sale_ht_total, ttc_total: sale_ttc_total)
      outlet.update(ht_turnover: outlet_ht_turnover, ttc_turnover: outlet_ttc_turnover)
      @farm.update(ht_turnover: farm_ht_turnover, ttc_turnover: farm_ttc_turnover)
      redirect_to farm_pointsdevente_sale_path(@farm, outlet, sale)
    end
  end

  def update
    authorize @sales_line
    @sales_line.update(bed_id: params[:bed])
    redirect_to farm_pointsdevente_sale_path(@farm, @sales_line.sale.outlet, @sales_line.sale)
  end

  def destroy
    ht_total = @sales_line.ht_total
    ttc_total = @sales_line.ttc_total
    sale = @sales_line.sale
    outlet = @sales_line.sale.outlet
    authorize @sales_line
    if @sales_line.destroy
      sale_ht_total = sale.ht_total -= ht_total
      sale_ttc_total = sale.ttc_total -= ttc_total
      outlet_ht_turnover = outlet.ht_turnover -= ht_total
      outlet_ttc_turnover = outlet.ttc_turnover -= ttc_total
      farm_ht_turnover = @farm.ht_turnover -= ht_total
      farm_ttc_turnover = @farm.ttc_turnover -= ttc_total
      sale.update(ht_total: sale_ht_total, ttc_total: sale_ttc_total)
      outlet.update(ht_turnover: outlet_ht_turnover, ttc_turnover: outlet_ttc_turnover)
      @farm.update(ht_turnover: farm_ht_turnover, ttc_turnover: farm_ttc_turnover)

      redirect_to farm_pointsdevente_sale_path(@farm, outlet, sale)
    end
  end


  private

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end

  def set_sales_line
    @sales_line = SalesLine.find(params[:id])
  end

end
