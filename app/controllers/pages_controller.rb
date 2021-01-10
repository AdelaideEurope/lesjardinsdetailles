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
    @calendar_events = Event.where(event_category: "dated_admin")
    @admin_events = Event.where(event_category: "admin")
    @garden_events = Event.where(event_category: "garden")
    @presence_periods = PresencePeriod.all
    @event_colors = {"rdv": "teagreen", "vente": "greensheen"}
  end
end
