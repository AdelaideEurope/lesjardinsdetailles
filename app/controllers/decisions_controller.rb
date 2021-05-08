class DecisionsController < ApplicationController
  before_action :set_farm, only: [:index, :new, :create, :update, :edit, :destroy]
  before_action :set_decision, only: [:update, :edit, :destroy]


    def index
      if !params[:query]
        @decisions = Decision.where(farm_id: @farm.id).order("date DESC")
      elsif params[:query].present?
        sql_query = "object ILIKE :query OR details ILIKE :query OR comment ILIKE :query"
        @decisions = Decision.where(sql_query, query: "%#{params[:query]}%").where(farm_id: @farm.id, ).order("date DESC")
      else
        @decisions = Decision.where(farm_id: @farm.id).order("date DESC")
      end
      authorize @decisions
    end

    def new
      @decision = Decision.new
      authorize @decision
    end

    def create
      date = Date.parse(params[:decision][:date])
      @decision = Decision.new(farm_id: params[:farm_id], comment: params[:decision][:comment], object: params[:decision][:object], details: params[:decision][:details], date: date)
      authorize @decision
      if @decision.save
        flash[:notice] = "Allez hop, ça c'est fait ! 🤓"
        redirect_to farm_decisions_path(@farm)
      else
        redirect_to farm_decisions_path(@farm)
      end
    end

    def update
      if @decision.update(comment: params[:decision][:comment], object: params[:decision][:object], details: params[:decision][:details])
        redirect_to farm_decisions_path(@farm)
        flash[:notice] = "Modif' ✔"
      end
      authorize @decision
    end

    def destroy
      if @decision.destroy
        redirect_to farm_decisions_path(@farm)
        flash[:notice] = "Décision supprimée avec succès !"
      end
      authorize @decision
    end


    def set_farm
      @farm = Farm.find(params[:farm_id])
    end

    def set_decision
      @decision = Decision.find(params[:id])
    end



end
