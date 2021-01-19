class CropPlanLinesController < ApplicationController
  def index
    @crop_plan_lines = CropPlanLine.all
    authorize @crop_plan_lines
    @gardens = Garden.includes(beds: [crop_plan_lines: [product: [:product_group, :photo_attachment]]]).where(farm_id: current_user.farm_id)
    number_days_since_first_day_of_year = Date.today.strftime("%j").to_i
    @percentage_number_days_since_first_day_of_year = helpers.get_elapsed_days_since_beginning_of_year(number_days_since_first_day_of_year)
  end

  def update
    @crop_plan_line = CropPlanLine.find(params[:id])
    authorize @crop_plan_line
    @farm = Farm.find(params[:farm_id])
    @crop_plan_line.update(planting_date: @crop_plan_line.planting_date + 1.week)
    redirect_to farm_dashboard_path(@farm)
  end
end

