class EventsController < ApplicationController
  def index
    @events = Event.all
    @presence_periods = PresencePeriod.all
    @event_colors = {"rdv": "276259", "vente": "A1BD7F"}
    authorize @events
  end
end
