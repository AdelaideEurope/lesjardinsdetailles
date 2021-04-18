class InvoicesController < ApplicationController
  before_action :set_farm, only: [:new, :create, :index, :update, :show]
  before_action :set_outlet, only: [:new, :create, :update]
  before_action :set_invoice, only: [:show, :update]

  def new
    @invoiceable_sales = @outlet.sales.where("date <= ? AND invoice_id IS NULL", Date.today).order(:date)
    @invoice = Invoice.new
    authorize @invoice
    @invoice_id = Invoice.count + 1
  end

  def show
    authorize @invoice
    grouped_sales_lines
    @invoice_ht_total = @invoice.sales.map{|s| s.ht_total}.sum
    @tva = (@invoice_ht_total / 100) * 5.5

    @all_sales = @invoice.sales.map{|sale| "#{sale.date.to_date.strftime('%-d')} #{I18n.t(:month_names)[sale.date.to_date.strftime('%b').to_sym]}"}.to_sentence(words_connector: ', ', last_word_connector: ' et ')

    respond_to do |format|
      format.html { render :show }
      format.pdf {
        render :pdf => "show", :layout => 'pdf.html', encoding: 'utf8'
      }
    end
  end

  def create
    @invoice = Invoice.new(date: params[:invoice][:date], number: params[:invoice][:number], comment: params[:invoice][:comment], outlet_display_name: params[:invoice][:outlet_display_name], outlet_address: params[:invoice][:outlet_address], outlet_zip_code: params[:invoice][:outlet_zip_code], outlet_city: params[:invoice][:outlet_city], outlet_id: @outlet.id)
    if @invoice.save
      sales = params[:invoice_sales]
      sales.each do |sale_id|
        sale = Sale.find(sale_id.to_i)
        sale.update(invoice_id: @invoice.id)
      end
      redirect_to farm_pointsdevente_facture_path(@farm, @outlet, @invoice, format: "pdf")
    end
    authorize @invoice
  end

  def update
    authorize @invoice
    @invoice.update(sent: true)
    if params[:sales_index] == "true"
      redirect_to farm_ventes_path(@farm)
    else
      redirect_to farm_pointsdevente_path(@farm, @outlet)
    end
  end


  private

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end

  def set_outlet
    @outlet = Outlet.find(params[:pointsdevente_id])
  end

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def grouped_sales_lines
    @sales_lines = {}
    @invoice.sales.each do |sale|
      sale.sales_lines.each do |line|
        if !@sales_lines[[line.product, line.unit]].nil?
          ht_total = @sales_lines[[line.product, line.unit]][:ht_total] += line.ht_total
          quantity = @sales_lines[[line.product, line.unit]][:quantity] += line.quantity
          ht_unit_price = @sales_lines[[line.product, line.unit]][:ht_unit_price] += line.ht_unit_price
          @sales_lines[[line.product, line.unit]] = {ht_total: ht_total, quantity: quantity, ht_unit_price: ht_unit_price}
        else
          @sales_lines[[line.product, line.unit]] = {ht_total: line.ht_total, quantity: line.quantity, ht_unit_price: line.ht_unit_price}
        end
      end
    end
  end

end
