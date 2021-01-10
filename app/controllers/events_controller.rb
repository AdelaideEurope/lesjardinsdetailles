class EventsController < ApplicationController
  def index
    @events = Event.all
    @presence_periods = PresencePeriod.all
    @calendar_events = Event.where(event_category: "dated_admin")
    @event_colors = {"rdv": "teagreen", "vente": "greensheen"}
    authorize @events
  end
end
