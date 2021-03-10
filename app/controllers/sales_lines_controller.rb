class SalesLinesController < ApplicationController
  before_action :set_farm, only: [:new, :create, :index, :update, :destroy]

  def create
    sale = params[:sale].to_i
    outlet = params[:outlet].to_i
    @sales_line = SalesLine.new(product_id: params[:sales_line][:product].to_i, bed_id: params[:sales_line][:bed].to_i, unit: params[:sales_line][:unit], ht_unit_price: params[:sales_line][:ht_unit_price].to_i, ttc_unit_price: params[:sales_line][:ttc_unit_price].to_i, ht_total: params[:sales_line][:ht_total].to_i, ttc_total: params[:sales_line][:ttc_total].to_i, quantity: params[:sales_line][:quantity].to_i, sale_id: sale, date: params[:date])
    authorize @sales_line
    @sales_line.save
    redirect_to farm_pointsdevente_sale_path(@farm, outlet, sale)
  end

  def destroy
    @sales_line = SalesLine.find(params[:id])
    sale = @sales_line.sale
    outlet = @sales_line.sale.outlet
    authorize @sales_line
    @sales_line.destroy
    redirect_to farm_pointsdevente_sale_path(@farm, outlet, sale)
  end


  private

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end

end
