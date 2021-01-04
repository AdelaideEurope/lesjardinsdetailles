class CropPlanLinesController < ApplicationController
  def index
    @crop_plan_lines = CropPlanLine.all
    authorize @crop_plan_lines
    @gardens = Garden.includes(:beds)
    number_days_since_first_day_of_year = Date.today.strftime("%j").to_i
    @percentage_number_days_since_first_day_of_year = get_elapsed_days_since_beginning_of_year(number_days_since_first_day_of_year)
  end
end

