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
    if params[:sales_line][:product].to_i == 0
      flash[:alert] = "Attention, tu n'as pas indiqué le légume"
      redirect_to farm_pointsdevente_sale_path(@farm, outlet, sale)
    end

    if params[:sales_line][:unit] == "-"
      unit = Product.find(params[:sales_line][:product].to_i).general_unit
    else
      unit = params[:sales_line][:unit]
    end

    last_price = LastPrice.where(outlet_id: outlet_id, product_id: params[:sales_line][:product].to_i)[0]
    if last_price.nil?
      last_price_amount = (params[:sales_line][:ht_unit_price].to_f * 100).round
      LastPrice.create(outlet_id: outlet_id, product_id: params[:sales_line][:product].to_i, amount: [last_price_amount], unit: [params[:sales_line][:unit]])
    elsif !last_price.unit.include?(params[:sales_line][:unit])
      last_price_amount = (params[:sales_line][:ht_unit_price].to_f * 100).round
      last_price_unit = params[:sales_line][:unit]
      last_price_amounts = last_price.amount.push(last_price_amount)
      last_price_units = last_price.unit.push(last_price_unit)
      last_price.update(amount: last_price_amounts, unit: last_price_units)
    else
      last_price_amount = (params[:sales_line][:ht_unit_price].to_f * 100).round
      index_amount_to_replace = last_price.unit.find_index(params[:sales_line][:unit])
      last_price.amount[index_amount_to_replace] = last_price_amount
      last_price.save
    end

    if params[:beds].length == 1
      bed_id = params[:sales_line][:bed].to_i == 0 ? nil : params[:sales_line][:bed].to_i
      @sales_line = SalesLine.create(product_id: params[:sales_line][:product].to_i, bed_id: bed_id, unit: unit, ht_unit_price: ht_unit_price, ttc_unit_price: ttc_unit_price, ht_total: ht_total, ttc_total: ttc_total, quantity: params[:sales_line][:quantity].to_f, sale_id: sale_id, date: sale.date)
    else
      params[:beds].each do |bed|
        bed_id = bed.to_i
        each_ttc_total = ttc_total / params[:beds].length
        each_ht_total = ht_total / params[:beds].length
        each_quantity = params[:sales_line][:quantity].to_f / params[:beds].length

        @sales_line = SalesLine.create(product_id: params[:sales_line][:product].to_i, bed_id: bed_id, unit: unit, ht_unit_price: ht_unit_price, ttc_unit_price: ttc_unit_price, ht_total: each_ht_total, ttc_total: each_ttc_total, quantity: each_quantity, sale_id: sale_id, date: sale.date)
      end
    end
    sale_ht_total = sale.ht_total += ht_total
    sale_ttc_total = sale.ttc_total += ttc_total

    product_ht_total = @sales_line.product.ht_turnover += ht_total
    product_ttc_total = @sales_line.product.ttc_turnover += ttc_total
    @sales_line.product.update(ht_turnover: product_ht_total, ttc_turnover: product_ttc_total)

    outlet_ht_turnover = outlet.ht_turnover += ht_total
    outlet_ttc_turnover = outlet.ttc_turnover += ttc_total
    farm_ht_turnover = @farm.ht_turnover += ht_total
    farm_ttc_turnover = @farm.ttc_turnover += ttc_total
    sale.update(ht_total: sale_ht_total, ttc_total: sale_ttc_total)
    outlet.update(ht_turnover: outlet_ht_turnover, ttc_turnover: outlet_ttc_turnover)
    @farm.update(ht_turnover: farm_ht_turnover, ttc_turnover: farm_ttc_turnover)
    authorize @sales_line

    redirect_to farm_pointsdevente_sale_path(@farm, outlet, sale)
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
      product_ht_total = @sales_line.product.ht_turnover -= ht_total
      product_ttc_total = @sales_line.product.ttc_turnover -= ttc_total
      @sales_line.product.update(ht_turnover: product_ht_total, ttc_turnover: product_ttc_total)

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
