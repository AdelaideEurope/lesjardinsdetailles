class UserEventsController < ApplicationController
  before_action :set_user_event, only: [:destroy]
  before_action :set_farm, only: [:create, :destroy]

  def create
    params_start_date = params[:start_date]
    @user_event = UserEvent.new(user_id: params[:worker], event_id: params[:event])
    worker = User.where(id: params[:worker])[0]
    authorize @user_event
    if UserEvent.where(user_id: params[:worker], event_id: params[:event]).length > 0
      flash[:alert] = "#{worker.nickname.capitalize} est déjà sur cette tâche !"
      redirect_to farm_dashboard_path(@farm, start_date: params_start_date)
    elsif @user_event.save
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

  def destroy
    authorize @user_event
    params_start_date = params[:start_date]
    worker = @user_event.user
    @user_event.destroy
    flash[:notice] = "Finalement, #{worker.nickname.capitalize} pourra se la couler douce !"
    redirect_to farm_dashboard_path(@farm, start_date: params_start_date)
  end

  def set_user_event
    @user_event = UserEvent.find(params[:id])
  end

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end
end
