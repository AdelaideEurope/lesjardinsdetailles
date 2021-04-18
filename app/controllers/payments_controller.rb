class PaymentsController < ApplicationController
  before_action :set_farm, only: [:new, :create, :index, :update, :show]
  before_action :set_outlet, only: [:new, :create, :update]
  before_action :set_payment, only: [:show, :update]


  def create
    @sale = Sale.find(params[:sale_id])
    has_invoice = @outlet.has_invoice
    if has_invoice
      @payment = Payment.new(date: Date.today, outlet_id: @outlet.id, paid_amount: @sale.ht_total, invoice_id: @sale.invoice.id)
    else
      @payment = Payment.new(date: Date.today, outlet_id: @outlet.id, paid_amount: @sale.ttc_total, sale_id: @sale.id)
    end

    if @payment.save
      flash[:notice] = "Paiement enregistré avec succès !"
      redirect_to farm_pointsdevente_path(@farm, @outlet)
    end
    authorize @payment
  end

  private

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end

  def set_outlet
    @outlet = Outlet.find(params[:pointsdevente_id])
  end

  def set_invoice
    @invoice = Invoice.find(params[:facture_id])
  end

  def set_payment
    @payment = Payment.find(params[:id])
  end
end
