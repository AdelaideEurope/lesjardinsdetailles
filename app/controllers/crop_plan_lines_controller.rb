class CropPlanLinesController < ApplicationController
  before_action :set_crop_plan_line, only: [:update]
  before_action :set_farm, only: [:update]

  def index
    @farm = Farm.find(params[:farm_id])
    @crop_plan_lines = CropPlanLine.all
    authorize @crop_plan_lines
    @gardens = Garden.includes(beds: [crop_plan_lines: [{product: :product_group}, crop_plan_line_events: [:product, :bed]]])
    number_days_since_first_day_of_year = Date.today.strftime("%j").to_i
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def update
    authorize @crop_plan_line

    if params[:postpone] && params[:harvesting]
      start_date = params[:start_date]
      crop_plan_line_event_to_update = @crop_plan_line.crop_plan_line_events.where(order: 3)
      new_date = @crop_plan_line.harvest_start_date + 1.week

      if crop_plan_line_event_to_update.update(date_planned: new_date) && @crop_plan_line.update(harvest_start_date: new_date)
        flash[:notice] = "#{@crop_plan_line.product.name.capitalize} : début de la récolte décalé à la semaine #{new_date.strftime('%W').to_i}  !"
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      end
    end
  end

  def set_crop_plan_line
    @crop_plan_line = CropPlanLine.find(params[:id])
  end

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end
end

