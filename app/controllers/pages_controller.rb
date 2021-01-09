class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :about ]

  def home
    authorize :page
  end

  def about
    authorize :page
    @products = Product.all
  end

  def dashboard
    authorize :page
    @events = Event.all
    @presence_periods = PresencePeriod.all
    @event_colors = {"rdv": "teagreen", "vente": "greensheen"}
  end
end
