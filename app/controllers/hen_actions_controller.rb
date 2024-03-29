class HenActionsController < ApplicationController
  before_action :set_farm, only: [:index, :new, :create, :update, :edit, :destroy]
  before_action :set_hen_action, only: [:update, :edit, :destroy]


    def index
      if !params[:query]
        @hen_actions = HenAction.where(farm_id: @farm.id).order("date DESC")
      elsif params[:query].present?
        sql_query = "action ILIKE :query OR comment ILIKE :query"
        @hen_actions = HenAction.where(sql_query, query: "%#{params[:query]}%").where(farm_id: @farm.id, ).order("date DESC")
      else
        @hen_actions = HenAction.where(farm_id: @farm.id).order("date DESC")
      end
      authorize @hen_actions
      daily_egg_counts
    end

    def new
      @hen_action = HenAction.new
      authorize @hen_action
    end

    def create
      date = Date.parse(params[:hen_action][:date])
      @hen_action = HenAction.new(farm_id: params[:farm_id], comment: params[:hen_action][:comment], action: params[:hen_action][:action], date: date)
      authorize @hen_action
      if @hen_action.save
        flash[:notice] = "C'est noté ! 🐔"
        redirect_to farm_poulettes_path(@farm)
      else
        redirect_to farm_poulettes_path(@farm)
      end
    end

    def update
      if @hen_action.update(comment: params[:hen_action][:comment], action: params[:hen_action][:action])
        redirect_to farm_poulettes_path(@farm)
        flash[:notice] = "Modif' ✔"
      end
      authorize @hen_action
    end

    def destroy
      if @hen_action.destroy
        redirect_to farm_poulettes_path(@farm)
        flash[:notice] = "Action supprimée avec succès !"
      end
      authorize @hen_action
    end

    private

    def set_farm
      @farm = Farm.find(params[:farm_id])
    end

    def set_hen_action
      @hen_action = HenAction.find(params[:id])
    end

    def daily_egg_counts
      @daily_egg_counts = {}
      DailyEggCount.all.order(:date).each {|c| @daily_egg_counts[c.date.strftime('%d/%m')] = c.egg_count}
    end

end
