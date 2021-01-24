class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy]
  before_action :set_farm, only: [:index, :create, :edit, :update, :destroy]

  def index
    @events = Event.where(farm_id: current_user.farm_id)
    @presence_periods = PresencePeriod.joins(:users).where(users: { farm_id: current_user.farm_id }).uniq
    @calendar_events = Event.where("farm_id = ? AND event_category = ?", @farm, "dated_admin")
    authorize @events
  end

  def new
    @new_event = Event.new
  end

  def create
    params_start_date = params[:start_date]
    !params_start_date.nil? ? date = params[:start_date] : date = Date.today
    @new_event = Event.new(date: date, description: params[:event][:description], comment: params[:event][:comment], details: params[:event][:details], event_category: params[:event_category], farm_id: current_user.farm_id)
    authorize @new_event
    if @new_event.save
      if @new_event.event_category == "garden"
        anchor = "garden-event-#{@new_event.id}"
        flash[:notice] = "Tâche de jardin créée avec succès !"
      elsif @new_event.event_category == "admin"
        anchor = "admin-event-#{@new_event.id}"
        flash[:notice] = "All good, on oublie 😎"
      end
      redirect_to farm_dashboard_path(@farm, start_date: params_start_date, anchor: anchor)
    else
      redirect_to farm_dashboard_path(@farm, start_date: params_start_date)
    end
  end

  def edit
  end

  def update
    if params[:event_done]
      start_date = params[:start_date]
      if @event.update(date_done: Date.today)
        redirect_to farm_dashboard_path(@farm, start_date: start_date, anchor: "garden-event-#{@event.id}")
      else
        redirect_to farm_dashboard_path(@farm, start_date: start_date, anchor: "garden-event-#{@event.id}")
      end
    elsif params[:postpone]
      start_date = params[:start_date]
      new_date = @event.date + 1.week
      if @event.update(date: new_date)
        flash[:notice] = "Tâche décalée à la semaine #{new_date.strftime('%W').to_i}  !"
        if @event.event_category == "garden"
          redirect_to farm_dashboard_path(@farm, start_date: start_date, anchor: "tour-des-jardins")
        elsif @event.event_category == "admin"
          redirect_to farm_dashboard_path(@farm, start_date: start_date, anchor: "decharge-mentale")
        end
      else
        redirect_to farm_dashboard_path(@farm, start_date: start_date, anchor: "tour-des-jardins")
      end
    else
      start_date = params[:start_date]
      if @event.update(description: params[:description], comment: params[:comment], details: params[:details])
        redirect_to farm_dashboard_path(@farm, start_date: start_date, anchor: "garden-event-#{@event.id}")
      else
        redirect_to farm_dashboard_path(@farm, start_date: start_date, anchor: "garden-event-#{@event.id}")
      end
    end
    authorize @event
  end

  def destroy
    authorize @event
    start_date = params[:start_date]
    @event.destroy
    flash[:notice] = "Tâche supprimée avec succès !"
    redirect_to farm_dashboard_path(@farm, start_date: start_date)
  end

  private
  def set_event
    @event = Event.find(params[:id])
  end

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end
end
