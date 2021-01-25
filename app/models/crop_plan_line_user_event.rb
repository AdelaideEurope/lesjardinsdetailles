class CropPlanLineUserEvent < ApplicationRecord
  belongs_to :crop_plan_line_event
  belongs_to :user
end
