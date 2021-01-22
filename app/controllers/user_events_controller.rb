class UserEventsController < ApplicationController
  def create
    @user_event = UserEvent.create(user_id: params[:worker], event_id: params[:event])
    worker = User.where(id: params[:worker])[0]
    authorize @user_event
    @farm = Farm.find(params[:farm_id])
    if @user_event.save
      flash[:notice] = "#{worker.nickname.capitalize} #{worker.gender == "F" ? "ajoutée" : "ajouté"} avec succès !"
      redirect_to farm_dashboard_path(@farm)
    else
      redirect_to farm_dashboard_path(@farm)
    end
  end

  def update
  end
end
