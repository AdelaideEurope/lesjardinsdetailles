class EventsController < ApplicationController
  def index
    @events = Event.where(farm_id: current_user.farm_id)
    @presence_periods = PresencePeriod.joins(:users).where(users: { farm_id: current_user.farm_id }).uniq
    @calendar_events = Event.where("farm_id = ? AND event_category = ?", current_user.farm_id , "dated_admin")
    @event_colors = {"rdv": "teagreen", "vente": "greensheen"}
    authorize @events
  end
end
