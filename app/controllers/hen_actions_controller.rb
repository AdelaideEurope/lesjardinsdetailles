class HenActionsController < ApplicationController
  before_action :set_farm, only: [:index, :new, :create, :update, :edit, :destroy]
  before_action :set_hen_action, only: [:update, :edit, :destroy]


    def index
      if !params[:query]
        @hen_actions = HenAction.where(farm_id: @farm.id).order("date DESC")
      elsif params[:query].present?
        sql_query = "action ILIKE :query"
        @hen_actions = HenAction.where(sql_query, query: "%#{params[:query]}%").where(farm_id: @farm.id, ).order("date DESC")
      else
        @hen_actions = HenAction.where(farm_id: @farm.id).order("date DESC")
      end
      authorize @hen_actions
    end

    def new
      @hen_action = HenAction.new
      authorize @hen_action
    end

    def create
      year = params[:hen_action]["date(1i)"]
      month = params[:hen_action]["date(2i)"].length == 1 ? "0" + params[:hen_action]["date(2i)"] : params[:hen_action]["date(2i)"]
      day = params[:hen_action]["date(3i)"]
      date = year + month + day
      @hen_action = HenAction.new(farm_id: params[:farm_id], comment: params[:hen_action][:comment], action: params[:hen_action][:action], date: Date.parse(date))
      authorize @hen_action
      if @hen_action.save
        flash[:notice] = "C'est noté ! 🐔"
        redirect_to farm_hen_actions_path(@farm)
      else
        redirect_to farm_hen_actions_path(@farm)
      end
    end

    def update
      if @hen_action.update(comment: params[:hen_action][:comment], action: params[:hen_action][:action])
        redirect_to farm_hen_actions_path(@farm)
        flash[:notice] = "Modif' ✔"
      end
      authorize @hen_action
    end

    def destroy
      if @hen_action.destroy
        redirect_to farm_hen_actions_path(@farm)
        flash[:notice] = "Action supprimée avec succès !"
      end
      authorize @hen_action
    end


    def set_farm
      @farm = Farm.find(params[:farm_id])
    end

    def set_hen_action
      @hen_action = HenAction.find(params[:id])
    end

end
