class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update]
  before_action :set_farm, only: [:index, :create, :edit, :update]

  def index
    @events = Event.where(farm_id: current_user.farm_id)
    @presence_periods = PresencePeriod.joins(:users).where(users: { farm_id: current_user.farm_id }).uniq
    @calendar_events = Event.where("farm_id = ? AND event_category = ?", @farm, "dated_admin")
    @event_colors = {"rdv": "teagreen", "vente": "greensheen"}
    authorize @events
  end

  def new
    @new_event = Event.new
  end

  def create
    params_start_date = params[:start_date]
    !params_start_date.nil? ? date = params[:start_date] : date = Date.today
    @new_event = Event.new(date: date, description: params[:event][:description], comment: params[:event][:comment], details: params[:event][:details], event_category: "garden", farm_id: current_user.farm_id)
    authorize @new_event
    if @new_event.save
      flash[:notice] = "Tâche de jardin créée avec succès !"
      redirect_to farm_dashboard_path(@farm, start_date: params_start_date)
    else
      redirect_to farm_dashboard_path(@farm, start_date: params_start_date)
    end
  end

  def edit
  end

  def update
    if params[:event_done]
      if @event.update(date_done: Date.today)
        redirect_to farm_dashboard_path(@farm)
      else
        redirect_to farm_dashboard_path(@farm)
      end
    elsif params[:postpone]
      start_date = params[:start_date]
      new_date = @event.date + 1.week
      if @event.update(date: new_date)
        flash[:notice] = "Tâche de jardin décalée à la semaine #{new_date.strftime('%U').to_i}  !"
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      else
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      end
    else
      start_date = params[:start_date]
      if @event.update(description: params[:description], comment: params[:comment], details: params[:details])
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      else
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      end
    end
    authorize @event
  end

  private
  def set_event
    @event = Event.find(params[:id])
  end

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end
end
