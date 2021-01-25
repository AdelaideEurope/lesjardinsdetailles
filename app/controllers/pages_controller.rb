class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :about ]

  def home
    authorize :page
  end

  def about
    authorize :page
    @products = Product.where(farm_id: current_user.farm_id)
  end

  def dashboard
    authorize :page
    @events = Event.all
    @farm = current_user.farm
    @calendar_events = Event.where("farm_id = ? AND event_category = ?", current_user.farm_id , "dated_admin")
    @admin_events = Event.admin_events(params[:start_date])
    @garden_events = Event.garden_events(params[:start_date])
    @presence_periods = PresencePeriod.joins(:users).where(users: { farm_id: current_user.farm_id }).uniq

    @week_planting = params[:start_date].nil? ? CropPlanLine.where("planting_date BETWEEN ? AND ?", Date.today.beginning_of_week, Date.today.end_of_week) : CropPlanLine.where("planting_date BETWEEN ? AND ?", Date.parse(params[:start_date]).beginning_of_week, Date.parse(params[:start_date]).end_of_week).includes(:product, bed: [:garden]).sort_by(&:id)
    @week_harvesting = params[:start_date].nil? ? CropPlanLine.where("harvest_start_date < ? AND harvest_end_date > ?", Date.today.beginning_of_week, Date.today.end_of_week) : CropPlanLine.where("harvest_start_date < ? AND harvest_end_date > ?", Date.parse(params[:start_date]).beginning_of_week, Date.parse(params[:start_date]).end_of_week).includes(:product, bed: [:garden]).sort_by(&:product)
    @week_planting2 = CropPlanLineEvent.week_planting(params[:start_date])
    @week_bed_preparation_2_weeks = params[:start_date].nil? ? CropPlanLine.where("planting_date BETWEEN ? AND ?", Date.today.beginning_of_week + 2.week, Date.today.end_of_week + 2.week) : CropPlanLine.where("planting_date BETWEEN ? AND ?", Date.parse(params[:start_date]).beginning_of_week + 2.week, Date.parse(params[:start_date]).end_of_week + 2.week).includes(:product, bed: [:garden]).sort_by(&:id)
    @week_bed_preparation_1_week = params[:start_date].nil? ? CropPlanLine.where("planting_date BETWEEN ? AND ?", Date.today.beginning_of_week + 1.week, Date.today.end_of_week + 1.week) : CropPlanLine.where("planting_date BETWEEN ? AND ?", Date.parse(params[:start_date]).beginning_of_week + 1.week, Date.parse(params[:start_date]).end_of_week + 1.week).includes(:product, bed: [:garden]).sort_by(&:id)

    @workers = @farm.workers
    @new_event = Event.new
  end

  private

  # def garden_events
  #   if params[:start_date].nil?
  #     @garden_events = Event.where("farm_id = ? AND event_category = ? AND (date BETWEEN ? AND ?)", 1, "garden", Date.today.beginning_of_week, Date.today.end_of_week)
  #   else
  #     @garden_events = Event.where("farm_id = ? AND event_category = ? AND (date BETWEEN ? AND ?)", 1, "garden", Date.parse(params[:start_date]).beginning_of_week, Date.parse(params[:start_date]).end_of_week)
  #   end
  # end
end
