class CropPlanLinesController < ApplicationController
  def index
    @crop_plan_lines = CropPlanLine.all
    authorize @crop_plan_lines
    @gardens = Garden.includes(:beds)
    get_elapsed_days_since_beginning_of_year
  end
end

  def get_elapsed_days_since_beginning_of_year
    number_days_since_first_day_of_year = Date.today.strftime("%j").to_i
    @percentage_number_days_since_first_day_of_year = ((number_days_since_first_day_of_year * 100) / 365).to_i
  end
