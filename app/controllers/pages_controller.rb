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
    @done_admin_events = Event.done_admin_events(params[:start_date], @farm.id)
    @todo_admin_events = Event.todo_admin_events(params[:start_date], @farm.id)
    @admin_events = Event.admin_events(params[:start_date], @farm.id)
    @garden_events = Event.garden_events(params[:start_date], @farm.id)
    @presence_periods = PresencePeriod.joins(:users).where(users: { farm_id: current_user.farm_id }).uniq

    @week_harvesting = CropPlanLine.week_harvesting(params[:start_date])
    @week_planting = CropPlanLineEvent.week_planting(params[:start_date])
    @week_bed_preparation_2_weeks = CropPlanLineEvent.week_bed_preparation_2_weeks(params[:start_date])
    @week_bed_preparation_1_week = CropPlanLineEvent.week_bed_preparation_1_week(params[:start_date])

    @workers = @farm.workers
    @new_event = Event.new

    @gardens = Garden.includes(beds: [crop_plan_lines: [{product: [:product_group, :fertilization_need]}, crop_plan_line_events: [:product, :bed]]])
    if params[:to_harvest].present?
      to_harvest(params[:to_harvest])
    else
      to_harvest(Date.today)
    end
    @egg_count = DailyEggCount.new
    @daily_egg_counts_this_week = DailyEggCount.week_egg_count(params[:start_date])
  end

  private

  def to_harvest(date)
    @no_sale_today = true
    @sales_lines_today = SalesLine.where(date: date)
    @basket_lines_today = BasketLine.where(date: date)
    @sales_lines_today.length != 0 || @basket_lines_today.length != 0 ? @no_sale_today = false : true
    @to_harvest_lines = Hash.new { |to_harvest, product| to_harvest[product] = { unit: "", quantity: "".to_f, bed: [] } }
    @basket_lines_today.sort_by(&:product).each do |line|
      @to_harvest_lines[line.product.name.capitalize][:unit] = line.unit
      @to_harvest_lines[line.product.name.capitalize][:quantity] += (line.quantity * line.basket.quantity)
      @to_harvest_lines[line.product.name.capitalize][:bed].push(line.bed.full_name) if !line.bed.nil?
    end
    @sales_lines_today.sort_by(&:product).each do |line|
      @to_harvest_lines[line.product.name.capitalize][:unit] = line.unit
      @to_harvest_lines[line.product.name.capitalize][:quantity] += line.quantity
      @to_harvest_lines[line.product.name.capitalize][:bed].push(line.bed.full_name) if !line.bed.nil?
    end
  end
end
