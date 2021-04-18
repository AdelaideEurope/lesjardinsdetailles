class DeliverySlipsController < ApplicationController
  before_action :set_farm, only: [:new, :create, :index, :update, :show]
  before_action :set_outlet, only: [:new, :create]
  before_action :set_sale, only: [:new, :create, :show, :update]
  before_action :set_delivery_slip, only: [:show, :update]

  def new
    @delivery_slip = DeliverySlip.new
    authorize @delivery_slip
    @delivery_slip_id = DeliverySlip.count + 1
    grouped_sales_lines
  end

  def create
    date = Date.parse(params[:delivery_slip][:date])
    @delivery_slip = DeliverySlip.new(sale_id: @sale.id, date: date, comment: params[:delivery_slip][:comment], number: params[:delivery_slip][:number], outlet_display_name: params[:delivery_slip][:outlet_display_name], outlet_address: params[:delivery_slip][:outlet_address], outlet_zip_code: params[:delivery_slip][:outlet_zip_code], outlet_city: params[:delivery_slip][:outlet_city])
    authorize @delivery_slip
    @delivery_slip.save
      flash[:notice] = "Le voici le voilà le bon de livraison tout chaud !"
      redirect_to farm_pointsdevente_sale_livraison_path(@farm, @outlet, @sale, @delivery_slip, format: "pdf")
    end

  def show
    authorize @delivery_slip
    @tva = (@sale.ht_total / 100) * 5.5
    grouped_sales_lines
    respond_to do |format|
      format.html { render :show }
      format.pdf {
        render :pdf => "show", :layout => 'pdf.html', encoding: 'utf8'
      }
    end
  end

  def update
    authorize @delivery_slip
    @delivery_slip.update(confirmed: true)
    if params[:sales_index] == "true"
      redirect_to farm_ventes_path(@farm)
    else
      redirect_to farm_pointsdevente_path(@farm, @sale.outlet)
    end
  end

  private

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end

  def set_outlet
    @outlet = Outlet.find(params[:pointsdevente_id])
  end

  def set_sale
    @sale = Sale.find(params[:sale_id])
  end

  def set_delivery_slip
    @delivery_slip = DeliverySlip.find(params[:id])
  end

  def grouped_sales_lines
    @sales_lines = {}
    @sale.sales_lines.each do |line|
      if !@sales_lines[[line.product, line.unit]].nil?
        ttc_total = @sales_lines[[line.product, line.unit]][:ttc_total] += line.ttc_total
        ht_total = @sales_lines[[line.product, line.unit]][:ht_total] += line.ht_total
        quantity = @sales_lines[[line.product, line.unit]][:quantity] += line.quantity
        ht_unit_price = @sales_lines[[line.product, line.unit]][:ht_unit_price] += line.ht_unit_price
        ttc_unit_price = @sales_lines[[line.product, line.unit]][:ttc_unit_price] += line.ttc_unit_price
        @sales_lines[[line.product, line.unit]] = {ttc_total: ttc_total, ht_total: ht_total, quantity: quantity, ht_unit_price: ht_unit_price, ttc_unit_price: ttc_unit_price}
      else
        @sales_lines[[line.product, line.unit]] = {ttc_total: line.ttc_total, ht_total: line.ht_total, quantity: line.quantity, ht_unit_price: line.ht_unit_price, ttc_unit_price: line.ttc_unit_price}
      end
    end
  end
end
