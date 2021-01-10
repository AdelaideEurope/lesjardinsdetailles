class EventsController < ApplicationController
  def index
    @events = Event.all
    @presence_periods = PresencePeriod.all
    @event_colors = {"rdv": "teagreen", "vente": "greensheen"}
    authorize @events
  end
end
