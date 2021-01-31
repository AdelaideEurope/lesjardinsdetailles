class CropPlanLine < ApplicationRecord
  belongs_to :bed
  belongs_to :product
  belongs_to :vegetable_variet, optional: true
  has_many :crop_plan_line_events

  def has_comment?
    !self.comment.nil? && !self.comment.empty?
  end

  def self.week_harvesting(params)
    if params.nil?
      self.where("harvest_start_date <= ? AND harvest_end_date >= ?", Date.today.beginning_of_week, Date.today.end_of_week - 1.week).includes(:product, :crop_plan_line_events, bed: [:garden]).where(crop_plan_line_events: {order: 3}).sort_by(&:id)
    else
      self.where("harvest_start_date <= ? AND harvest_end_date >= ?", Date.parse(params).beginning_of_week, Date.parse(params).end_of_week - 1.week).includes(:product, :crop_plan_line_events, bed: [:garden]).where(crop_plan_line_events: {order: 3}).sort_by(&:id)
    end
  end
end
