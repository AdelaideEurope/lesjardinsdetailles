class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :about ]

  def home
    authorize :page
  end

  def about
    authorize :page
    @products = Product.where(farm_id: current_user.farm_id)
  end

  def dashboard
    authorize :page
    @events = Event.all
    @calendar_events = Event.where("farm_id = ? AND event_category = ?", current_user.farm_id , "dated_admin")
    @admin_events = Event.where("farm_id = ? AND event_category = ?", current_user.farm_id , "admin")
    @garden_events = Event.where("farm_id = ? AND event_category = ?", current_user.farm_id , "garden")
    @presence_periods = PresencePeriod.joins(:users).where(users: { farm_id: current_user.farm_id }).uniq
    @event_colors = {"rdv": "teagreen", "vente": "greensheen"}
  end
end
