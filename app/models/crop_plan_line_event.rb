class CropPlanLineEvent < ApplicationRecord
  belongs_to :crop_plan_line
  has_many :crop_plan_line_user_events
end
