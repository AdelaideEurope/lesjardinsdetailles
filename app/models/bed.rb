class Bed < ApplicationRecord
  belongs_to :garden
  has_many :crop_plan_lines
  has_many :crop_plan_line_events
  has_many :products, through: :crop_plan_lines
end
