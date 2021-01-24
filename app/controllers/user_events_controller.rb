class UserEventsController < ApplicationController
  def create
    params_start_date = params[:start_date]
    @user_event = UserEvent.new(user_id: params[:worker], event_id: params[:event])
    worker = User.where(id: params[:worker])[0]
    authorize @user_event
    @farm = Farm.find(params[:farm_id])
    if @user_event.save
      if @user_event.event.event_category == "garden"
        anchor = "garden-event-#{@user_event.event.id}"
      elsif @user_event.event.event_category == "admin"
        anchor = "admin-event-#{@user_event.event.id}"
      end

      flash[:notice] = "#{worker.nickname.capitalize} #{worker.is_female? ? "ajoutée" : "ajouté"} avec succès !"
      redirect_to farm_dashboard_path(@farm, start_date: params_start_date, anchor: anchor)
    else
      redirect_to farm_dashboard_path(@farm, start_date: params_start_date)
    end
  end

  def update
  end
end
