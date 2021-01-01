class CropPlanLine < ApplicationRecord
  belongs_to :bed
  belongs_to :product
  belongs_to :vegetable_variet, optional: true
end
