class EventsController < ApplicationController
  def index
    @events = Event.where(farm_id: current_user.farm_id)
    @presence_periods = PresencePeriod.joins(:users).where(users: { farm_id: current_user.farm_id }).uniq
    @calendar_events = Event.where("farm_id = ? AND event_category = ?", current_user.farm_id , "dated_admin")
    @event_colors = {"rdv": "teagreen", "vente": "greensheen"}
    authorize @events
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @farm = Farm.find(params[:farm_id])
    @event = Event.find(params[:id])
    if params[:event_done]
      if @event.update(date_done: Date.today)
        redirect_to farm_dashboard_path(@farm)
      else
        redirect_to farm_dashboard_path(@farm)
      end
    else
      if @event.update(event_params)
        redirect_to farm_dashboard_path(@farm)
      else
        redirect_to farm_dashboard_path(@farm)
      end
    end
    authorize @event
  end

  private
  def event_params
    params.permit(:id, :farm_id, :date, :details, :description, :comment)
  end
end
