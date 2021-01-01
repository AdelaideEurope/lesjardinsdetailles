class CropPlanLinesController < ApplicationController
  def index
    @crop_plan_lines = CropPlanLine.all
    authorize @crop_plan_lines
  end
end
