class VegetableVariet < ApplicationRecord
  belongs_to :product

  has_many :crop_plan_lines, optional: true
end
