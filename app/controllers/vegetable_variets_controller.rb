class VegetableVarietsController < ApplicationController
  before_action :set_variet, only: [:edit, :update]
  before_action :set_farm, only: [:index, :edit, :update, :new, :create]

  def new
    @vegetable_variet = VegetableVariet.new
    authorize @vegetable_variet
    @products = Product.all.pluck(:name)
  end

  def create
    product_id = Product.where(name: params[:vegetable_variet][:product_id])[0].id
    @vegetable_variet = VegetableVariet.new(name: params[:vegetable_variet][:name], details: params[:vegetable_variet][:details], product_id: product_id)
    authorize @vegetable_variet
    if @vegetable_variet.save
      flash[:notice] = "Produit modifié avec succès !"
      redirect_to farm_produits_path(@farm)
    else
      render :new
    end
  end

  def edit
    authorize @vegetable_variet
    @products = Product.all.pluck(:name)
  end

  def update
    authorize @vegetable_variet
    product_id = Product.where(name: params[:vegetable_variet][:product_id])[0].id
    if @vegetable_variet.update(name: params[:vegetable_variet][:name], details: params[:vegetable_variet][:details], product_id: product_id)
      flash[:notice] = "Produit modifié avec succès !"
      redirect_to farm_produits_path(@farm)
    else
      render :edit
    end
  end


  private
  def set_variet
    @vegetable_variet = VegetableVariet.find(params[:id])
  end

  def set_farm
    @farm = Farm.find(params[:farm_id])
  end

  def vegetable_variet_params
    params.require(:vegetable_variet).permit(:name, :details, :product_id)
  end

end
