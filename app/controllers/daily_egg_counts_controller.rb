class DailyEggCountsController < ApplicationController
    before_action :set_daily_egg_count, only: [:edit, :update]
    before_action :set_farm, only: [:index, :edit, :update, :new, :create, :destroy]

    def create
      params_start_date = params[:start_date]
      date = Date.parse(params[:daily_egg_count][:date])
      @daily_egg_count = DailyEggCount.new(farm_id: params[:farm_id], egg_count: params[:daily_egg_count][:egg_count], date: date)
      authorize @daily_egg_count
      if @daily_egg_count.save
        flash[:notice] = "C'est noté ! 🥚"
        redirect_to farm_dashboard_path(@farm, start_date: params_start_date.to_date.strftime)
      else
        redirect_to farm_dashboard_path(@farm, start_date: params_start_date.to_date.strftime)
      end
    end

  private
  def set_daily_egg_count
    @daily_egg_count = DailyEggCount.find(params[:daily_egg_count_id])
  end

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end

end
