class Bed < ApplicationRecord
  belongs_to :garden
  has_many :crop_plan_lines
end
