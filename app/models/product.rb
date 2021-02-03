class Product < ApplicationRecord
  belongs_to :farm
  belongs_to :product_group

  has_one :fertilization_need, dependent: :destroy
  has_many :vegetable_variets
  has_many :crop_plan_lines
  has_many :crop_plan_line_events

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_one_attached :photo

  def has_ferti?
    !self.fertilization_need.nil?
  end

  def has_ferti_indicated?
    !self.fertilization_need.nil? && self.fertilization_need.fertilization_type != "" && self.fertilization_need.quantity != "" && self.fertilization_need.quantity != nil && self.fertilization_need.unit != "" && self.fertilization_need.unit != nil
  end

  def has_variets?
    self.vegetable_variets.any?
  end

  def has_info_culture?
    info_count = 0
    !self.yearly_bed_count.nil? && self.yearly_bed_count != "" ? info_count += 1 : info_count += 0
    !self.yield_per_sqm.nil? && self.yield_per_sqm != "" ? info_count += 1 : info_count += 0
    !self.loss_percentage.nil? && self.loss_percentage != "" ? info_count += 1 : info_count += 0
    !self.spacing.nil? && self.spacing != "" ? info_count += 1 : info_count += 0
    !self.row_count.nil? && self.row_count != "" ? info_count += 1 : info_count += 0
    !self.growth_duration_in_weeks.nil? && self.growth_duration_in_weeks != "" ? info_count += 1 : info_count += 0
    !self.harvest_duration_in_weeks.nil? && self.harvest_duration_in_weeks != "" ? info_count += 1 : info_count += 0
    info_count > 0
  end
end
