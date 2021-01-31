class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :about ]

  def home
    authorize :page
    @farm = Farm.find(1)
  end

  def about
    authorize :page
    @products = Product.where(farm_id: current_user.farm_id)
  end

  def dashboard
    authorize :page
    @events = Event.all
    @farm = current_user.farm
    @calendar_events = Event.dated_admin_events(@farm.id)
    @admin_events = Event.admin_events(params[:start_date], @farm.id)
    @garden_events = Event.garden_events(params[:start_date], @farm.id)
    @presence_periods = PresencePeriod.joins(:users).where(users: { farm_id: current_user.farm_id }).uniq

    @week_harvesting = CropPlanLine.week_harvesting(params[:start_date])
    @week_planting = CropPlanLineEvent.week_planting(params[:start_date])
    @week_bed_preparation_2_weeks = CropPlanLineEvent.week_bed_preparation_2_weeks(params[:start_date])
    @week_bed_preparation_1_week = CropPlanLineEvent.week_bed_preparation_1_week(params[:start_date])

    @workers = @farm.workers
    @new_event = Event.new
  end
end
