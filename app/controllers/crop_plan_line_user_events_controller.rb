class CropPlanLineUserEventsController < ApplicationController
  before_action :set_crop_plan_line_user_event, only: [:destroy]
  before_action :set_farm, only: [:create, :destroy]

  def create
    params_start_date = params[:start_date]
    @crop_plan_line_user_event = CropPlanLineUserEvent.new(user_id: params[:worker], crop_plan_line_event_id: params[:event])
    worker = User.where(id: params[:worker])[0]
    authorize @crop_plan_line_user_event
    if @crop_plan_line_user_event.save
      flash[:notice] = "#{worker.nickname.capitalize} #{worker.is_female? ? "ajoutée" : "ajouté"} avec succès !"
      redirect_to farm_dashboard_path(@farm, start_date: params_start_date)
    else
      redirect_to farm_dashboard_path(@farm, start_date: params_start_date)
    end
  end

  def update
  end

  def destroy
    authorize @crop_plan_line_user_event
    params_start_date = params[:start_date]
    worker = @crop_plan_line_user_event.user
    @crop_plan_line_user_event.destroy
    flash[:notice] = "Finalement, #{worker.nickname.capitalize} pourra se la couler douce !"
    redirect_to farm_dashboard_path(@farm, start_date: params_start_date)
  end

  def set_crop_plan_line_user_event
    @crop_plan_line_user_event = CropPlanLineUserEvent.find(params[:id])
  end

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end
end
