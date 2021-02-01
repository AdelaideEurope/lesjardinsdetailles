class CropPlanLineEventsController < ApplicationController
  before_action :set_crop_plan_line_event, only: [:update]
  before_action :set_farm, only: [:update]

  def index
    # @crop_plan_line_events = CropPlanLineEvent.all
    # authorize @crop_plan_line_events
    # @gardens = Garden.includes(beds: [crop_plan_lines: [product: [:product_group, :photo_attachment]], :crop_plan_line_events]).where(farm_id: current_user.farm_id)
    # number_days_since_first_day_of_year = Date.today.strftime("%j").to_i
    # @percentage_number_days_since_first_day_of_year = helpers.get_elapsed_days_since_beginning_of_year(number_days_since_first_day_of_year)
  end

  def update
    authorize @crop_plan_line_event
    if params[:delete_comment]
      start_date = params[:start_date]
      if @crop_plan_line_event.update(comment: nil)
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      else
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      end
    elsif params[:add_comment] || params[:edit_comment]
      start_date = params[:start_date]
      if @crop_plan_line_event.update(comment: params[:crop_plan_line_event][:comment])
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      else
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      end
    elsif params[:event_done]
      start_date = params[:start_date]
      different_from_original = Date.today.strftime("%W") != @crop_plan_line_event.date_planned.strftime("%W")
      if @crop_plan_line_event.update(date_done: Date.today, different_from_original: different_from_original)
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      else
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      end

    elsif params[:postpone] && params[:preparing]
      start_date = params[:start_date]
      crop_plan_line = @crop_plan_line_event.crop_plan_line
      crop_plan_line_event_to_update = crop_plan_line.crop_plan_line_events.where(order: 1)
      new_date = crop_plan_line_event_to_update[0].date_planned + 1.week
      if crop_plan_line_event_to_update.update(date_planned: new_date)
        flash[:notice] = "Préparation de la planche décalée d'une semaine !"
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      end

    elsif params[:postpone]
      start_date = params[:start_date]
      new_date = @crop_plan_line_event.date_planned + 1.week
      crop_plan_line = @crop_plan_line_event.crop_plan_line
      case @crop_plan_line_event.order
      when 2
        crop_plan_line.update(planting_date: crop_plan_line.planting_date + 1.week, harvest_start_date: crop_plan_line.harvest_start_date + 1.week, harvest_end_date: crop_plan_line.harvest_end_date + 1.week)
      when 3
        crop_plan_line.update(harvest_start_date: crop_plan_line.harvest_start_date + 1.week, harvest_end_date: crop_plan_line.harvest_end_date + 1.week)
      when 4
        crop_plan_line.update(harvest_end_date: crop_plan_line.harvest_end_date + 1.week)
      end

      all_posterior_events_of_cpl = @crop_plan_line_event.crop_plan_line.crop_plan_line_events.select {|cple| cple.order > @crop_plan_line_event.order}
        all_posterior_events_of_cpl.each {|postcple| postcple.update(date_planned: postcple.date_planned + 1.week)}
      if @crop_plan_line_event.update(date_planned: new_date)
        flash[:notice] = "Tâche décalée à la semaine #{new_date.strftime('%W').to_i} !"
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      else
        redirect_to farm_dashboard_path(@farm, start_date: start_date)
      end
    end
  end

  def set_crop_plan_line_event
    @crop_plan_line_event = CropPlanLineEvent.find(params[:id])
  end

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end
end
