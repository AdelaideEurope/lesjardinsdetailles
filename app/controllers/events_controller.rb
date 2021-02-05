class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy]
  before_action :set_farm, only: [:index, :create, :edit, :update, :destroy]

  def index
    @events = Event.where(farm_id: current_user.farm_id)
    @new_event = Event.new
    @presence_periods = PresencePeriod.joins(:users).where(users: { farm_id: current_user.farm_id }).uniq
    @calendar_events = Event.where("farm_id = ? AND event_category = ?", @farm, "dated_admin")
    authorize @events
    @workers = @farm.workers
  end

  def new
    @new_event = Event.new
  end

  def create
    date = params[:event][:start_date]
    if params[:event_category] == "dated_admin"
      is_all_day = params[:event][:is_all_day] == '1'
      start_hour = params[:event]["start_hour(4i)"]+":"+params[:event]["start_hour(5i)"]
      end_hour = params[:event]["end_hour(4i)"]+":"+params[:event]["end_hour(5i)"]
      start_date_with_hour = DateTime.parse(date+"T"+start_hour)
      end_date_with_hour = DateTime.parse(date+"T"+end_hour)
      @new_event = Event.new(date: params[:start_date], description: params[:event][:description], comment: params[:event][:comment], details: params[:event][:details], event_subcategory: params[:event][:event_subcategory], event_category: params[:event_category], farm_id: current_user.farm_id, start_time: start_date_with_hour, end_time: end_date_with_hour, is_all_day: is_all_day)
      authorize @new_event
      if @new_event.save

        workers = params[:event][:worker_list].split(",").map{|el| el.to_i}
        counts = Hash.new(0)
        workers.each { |id| counts[id] += 1 }
        counts.delete_if {|key, value| value.even? }
        counts.each do |user_id, _value|
          UserEvent.create(user_id: user_id, event_id: @new_event.id)
        end

        if params[:to_calendar] == "true"
          redirect_to farm_calendrier_index_path(@farm, start_date: date)
        else
          redirect_to farm_dashboard_path(@farm, start_date: date)
        end
      else
        if params[:to_calendar] == "true"
          redirect_to farm_calendrier_index_path(@farm, start_date: date)
        else
          redirect_to farm_dashboard_path(@farm, start_date: date)
        end
      end
    else
      params_start_date = params[:start_date]
      !params_start_date.nil? ? date = params[:start_date] : date = Date.today
      @new_event = Event.new(date: date, description: params[:event][:description], comment: params[:event][:comment], details: params[:event][:details], event_category: params[:event_category], farm_id: current_user.farm_id)
      authorize @new_event
      if @new_event.save

        workers = params[:event][:worker_list].split(",").map{|el| el.to_i}
        counts = Hash.new(0)
        workers.each { |id| counts[id] += 1 }
        counts.delete_if {|key, value| value.even? }
        counts.each do |user_id, _value|
          UserEvent.create(user_id: user_id, event_id: @new_event.id)
        end

        if @new_event.event_category == "garden"
          # anchor = "garden-event-#{@new_event.id}"
          flash[:notice] = "Tâche de jardin créée avec succès !"
        elsif @new_event.event_category == "admin"
          # anchor = "admin-event-#{@new_event.id}"
          flash[:notice] = "All good, on oublie 😎"
        end
        redirect_to farm_dashboard_path(@farm, start_date: params_start_date)
      else
        redirect_to farm_dashboard_path(@farm, start_date: params_start_date)
      end
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
          redirect_to farm_dashboard_path(@farm, start_date: start_date)
        elsif @event.event_category == "admin"
          redirect_to farm_dashboard_path(@farm, start_date: start_date)
        end
      else
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      end
    elsif params[:event_category] == "dated_admin_event"
      start_date = params[:start_date]

      workers = params[:event][:worker_list].split(",").map{|el| el.to_i}
      @event.users.each {|w| workers.push(w.id)}
      @event.user_events.each {|ue| ue.destroy}
      counts = Hash.new(0)
      workers.each { |id| counts[id] += 1 }
      counts.delete_if {|key, value| value.even? }
      counts.each do |user_id, _value|
        UserEvent.create(user_id: user_id, event_id: @event.id)
      end

      if @event.update(description: params[:event][:description], comment: params[:event][:comment], details: params[:event][:details], event_subcategory: params[:event][:event_subcategory])
        if params[:to_calendar] == "true"
          redirect_to farm_calendrier_index_path(@farm, start_date: start_date)
        else
          redirect_to farm_dashboard_path(@farm, start_date: start_date)
        end
      else
        if params[:to_calendar] == "true"
          redirect_to farm_calendrier_index_path(@farm, start_date: start_date)
        else
          redirect_to farm_dashboard_path(@farm, start_date: start_date)
        end
      end
    else
      start_date = params[:start_date]
      if @event.update(description: params[:description], comment: params[:comment], details: params[:details])
        # , anchor: "garden-event-#{@event.id}"
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      else
        # , anchor: "garden-event-#{@event.id}"
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      end
    end
    authorize @event
  end

  def destroy
    authorize @event
    start_date = params[:start_date]
    @event.destroy
    if params[:event_subcategory] == "rdv"
      flash[:notice] = "Rendez-vous supprimé avec succès !"
    elsif params[:event_subcategory] == "vente"
      flash[:notice] = "Vente supprimée avec succès !"
    else
      flash[:notice] = "Tâche supprimée avec succès !"
    end
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
