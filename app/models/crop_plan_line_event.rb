class CropPlanLineEvent < ApplicationRecord
  belongs_to :crop_plan_line
  has_many :crop_plan_line_user_events

  def has_comment?
    !self.comment.nil? && !self.comment.empty?
  end

  def self.week_planting(params)
    if params.nil?
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "plantation", Date.today.beginning_of_week, Date.today.end_of_week).includes(:product, bed: [:garden]).sort_by(&:id)
    else
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "plantation", Date.parse(params).beginning_of_week, Date.parse(params).end_of_week).includes(crop_plan_line: [product: [:product_group, :photo_attachment]]).sort_by(&:id)
    end
  end

# (beds: [crop_plan_lines: [product: [:product_group, :photo_attachment]]])

    # @week_planting = params[:start_date].nil? ? CropPlanLine.where("planting_date BETWEEN ? AND ?", Date.today.beginning_of_week, Date.today.end_of_week) : CropPlanLine.where("planting_date BETWEEN ? AND ?", Date.parse(params[:start_date]).beginning_of_week, Date.parse(params[:start_date]).end_of_week).includes(:product, bed: [:garden]).sort_by(&:id)
    # @week_harvesting = params[:start_date].nil? ? CropPlanLine.where("harvest_start_date < ? AND harvest_end_date > ?", Date.today.beginning_of_week, Date.today.end_of_week) : CropPlanLine.where("harvest_start_date < ? AND harvest_end_date > ?", Date.parse(params[:start_date]).beginning_of_week, Date.parse(params[:start_date]).end_of_week).includes(:product, bed: [:garden]).sort_by(&:product)

    # @week_bed_preparation_2_weeks = params[:start_date].nil? ? CropPlanLine.where("planting_date BETWEEN ? AND ?", Date.today.beginning_of_week + 2.week, Date.today.end_of_week + 2.week) : CropPlanLine.where("planting_date BETWEEN ? AND ?", Date.parse(params[:start_date]).beginning_of_week + 2.week, Date.parse(params[:start_date]).end_of_week + 2.week).includes(:product, bed: [:garden]).sort_by(&:id)
    # @week_bed_preparation_1_week = params[:start_date].nil? ? CropPlanLine.where("planting_date BETWEEN ? AND ?", Date.today.beginning_of_week + 1.week, Date.today.end_of_week + 1.week) : CropPlanLine.where("planting_date BETWEEN ? AND ?", Date.parse(params[:start_date]).beginning_of_week + 1.week, Date.parse(params[:start_date]).end_of_week + 1.week).includes(:product, bed: [:garden]).sort_by(&:id)

end
