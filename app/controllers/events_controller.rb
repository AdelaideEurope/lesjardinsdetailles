class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy]
  before_action :set_farm, only: [:index, :create, :edit, :update, :destroy, :events_multiple_update]

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
    if params[:event_category] == "dated_admin"
      array_dates = params[:event][:start_date].split(", ")
      array_parsed_dates = array_dates.map {|d| DateTime.parse(d)}
      array_parsed_dates.each do |event_date|
        is_all_day = params[:event][:is_all_day] == '1'
        end_date_with_hour = DateTime.parse(event_date.to_s[0..-16] + " " + params[:event]["end_hour(4i)"]+":"+params[:event]["end_hour(5i)"])
        @new_event = Event.new(date: params[:start_date], description: params[:event][:description], comment: params[:event][:comment], details: params[:event][:details], event_subcategory: params[:event][:event_subcategory], event_category: params[:event_category], farm_id: current_user.farm_id, start_time: event_date, end_time: end_date_with_hour, is_all_day: is_all_day)
        authorize @new_event

        @new_event.save
        workers = params[:event][:worker_list].split(",").map{|el| el.to_i}
        counts = Hash.new(0)
        workers.each { |id| counts[id] += 1 }
        counts.delete_if {|key, value| value.even? }
        counts.each do |user_id, _value|
          UserEvent.create(user_id: user_id, event_id: @new_event.id)
        end
      end

      if params[:to_calendar] == "true"
        redirect_to farm_calendrier_index_path(@farm, start_date: params[:event][:start_date].split(", ")[0].to_date.strftime)
      else
        redirect_to farm_dashboard_path(@farm, start_date: params[:event][:start_date].split(", ")[0].to_date.strftime)
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
          flash[:notice] = "Tâche de jardin créée avec succès !"
        elsif @new_event.event_category == "admin"
          # anchor = "admin-event-#{@new_event.id}"
          flash[:notice] = "All good, on oublie 😎"
        end
        redirect_to farm_dashboard_path(@farm, start_date: params_start_date.to_date.strftime)
      else
        redirect_to farm_dashboard_path(@farm, start_date: params_start_date.to_date.strftime)
      end
    end
  end

  def edit
  end

  def update
    if params[:event_done]
      start_date = params[:start_date]
      if @event.update(date_done: Date.today)
        # , anchor: "garden-event-#{@event.id}"
        redirect_to farm_dashboard_path(@farm, start_date: start_date.to_date.strftime)
      else
        # , anchor: "garden-event-#{@event.id}"
        redirect_to farm_dashboard_path(@farm, start_date: start_date.to_date.strftime)
      end
    elsif params[:postpone]
      start_date = params[:start_date]
      new_date = @event.date + 1.week
      if @event.update(date: new_date)
        flash[:notice] = "Tâche décalée à la semaine #{new_date.strftime('%W').to_i}  !"
        if @event.event_category == "garden"
          redirect_to farm_dashboard_path(@farm, start_date: start_date.to_date.strftime)
        elsif @event.event_category == "admin"
          redirect_to farm_dashboard_path(@farm, start_date: start_date.to_date.strftime)
        end
      else
        redirect_to farm_dashboard_path(@farm, start_date: start_date.to_date.strftime)
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
          redirect_to farm_calendrier_index_path(@farm, start_date: start_date.to_date.strftime)
        else
          redirect_to farm_dashboard_path(@farm, start_date: start_date.to_date.strftime)
        end
      else
        if params[:to_calendar] == "true"
          redirect_to farm_calendrier_index_path(@farm, start_date: start_date.to_date.strftime)
        else
          redirect_to farm_dashboard_path(@farm, start_date: start_date.to_date.strftime)
        end
      end
    elsif params[:event][:cancel_done] == "1"
      start_date = params[:start_date]
      if @event.update(date_done: nil, description: params[:event][:description], comment: params[:event][:comment], details: params[:event][:details])
        redirect_to farm_dashboard_path(@farm, start_date: start_date.to_date.strftime)
      else
        redirect_to farm_dashboard_path(@farm, start_date: start_date.to_date.strftime)
      end
    elsif params[:event][:planned_week]
      date = Date.commercial(Date.today.year, params[:event][:planned_week].to_i)
      start_date = params[:start_date]
      if @event.update(description: params[:event][:description], comment: params[:event][:comment], details: params[:event][:details], date_done: params[:event][:date_done], date: date)
        # , anchor: "garden-event-#{@event.id}"
        redirect_to farm_dashboard_path(@farm, start_date: start_date.to_date.strftime)
      else
        # , anchor: "garden-event-#{@event.id}"
        redirect_to farm_dashboard_path(@farm, start_date: start_date.to_date.strftime)
      end
    else
      start_date = params[:start_date]
      if @event.update(description: params[:event][:description], comment: params[:event][:comment], details: params[:event][:details], date_done: params[:event][:date_done])
        # , anchor: "garden-event-#{@event.id}"
        redirect_to farm_dashboard_path(@farm, start_date: start_date.to_date.strftime)
      else
        # , anchor: "garden-event-#{@event.id}"
        redirect_to farm_dashboard_path(@farm, start_date: start_date.to_date.strftime)
      end
    end
    authorize @event
  end

  def events_multiple_update
    start_date = params[:start_date].to_date.strftime
    @todo_admin_events = Event.todo_admin_events(start_date, @farm.id)
    @todo_admin_events.each {|event| event.update(date: event.date + 1.week)}
    flash[:notice] = "Toutes les tâches non faites ont bien été décalées d'une semaine !"
    redirect_to farm_dashboard_path(@farm, start_date: (start_date.to_date + 1.week).to_s)
    authorize @todo_admin_events
  end

  def destroy
    authorize @event
    start_date = params[:start_date].to_date.strftime
    @event.destroy
    if params[:event_subcategory] == "rdv"
      flash[:notice] = "Rendez-vous supprimé avec succès !"
    elsif params[:event_subcategory] == "vente"
      flash[:notice] = "Vente supprimée avec succès !"
    else
      flash[:notice] = "Tâche supprimée avec succès !"
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

