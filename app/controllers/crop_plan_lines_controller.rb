class CropPlanLinesController < ApplicationController
  before_action :set_crop_plan_line, only: [:update, :edit]
  before_action :set_farm, only: [:update, :index, :edit]

  def index
    @crop_plan_lines = CropPlanLine.all
    authorize @crop_plan_lines
    @products = @farm.products.pluck(:name).sort
    @variets = @farm.products.joins(:vegetable_variets).pluck("vegetable_variets.name").push("").sort
    @gardens = Garden.includes(beds: [crop_plan_lines: [{product: [:product_group, :fertilization_need]}, crop_plan_line_events: [:product, :bed]]])
    number_days_since_first_day_of_year = Date.today.strftime("%j").to_i
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def edit
    authorize @crop_plan_line
  end

  def update
    authorize @crop_plan_line
    if params[:update_cpl]
      product_id = @farm.products.where(name: params[:crop_plan_line][:product])[0].id
      variet_id = params[:crop_plan_line][:variet] == "" ? nil : VegetableVariet.where(name: params[:crop_plan_line][:variet])[0].id
      garden_id = Garden.where(name: params[:crop_plan_line][:garden])[0].id
      bed_id = Bed.where(garden_id: garden_id, name: params[:crop_plan_line][:bed])[0].id

      if @crop_plan_line.update(planting_date: params[:crop_plan_line][:planting_date], harvest_start_date: params[:crop_plan_line][:harvest_start_date], harvest_end_date: params[:crop_plan_line][:harvest_end_date], product_id: product_id, vegetable_variet_id: variet_id, bed_id: bed_id, comment: params[:crop_plan_line][:comment])

        @crop_plan_line.crop_plan_line_events.where(order: 1).update(date_planned: params[:crop_plan_line][:planting_date].to_date - 2.week)
        @crop_plan_line.crop_plan_line_events.where(order: 2).update(date_planned: params[:crop_plan_line][:planting_date])
        @crop_plan_line.crop_plan_line_events.where(order: 3).update(date_planned: params[:crop_plan_line][:harvest_start_date])
        @crop_plan_line.crop_plan_line_events.where(order: 4).update(date_planned: params[:crop_plan_line][:harvest_end_date])

        flash[:notice] = "Ligne de plan de culture mise à jour !"
        redirect_to farm_plandeculture_index_path(@farm)
      end
    elsif params[:postpone] && params[:harvesting]
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

