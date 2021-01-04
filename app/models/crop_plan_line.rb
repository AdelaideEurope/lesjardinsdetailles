class CropPlanLine < ApplicationRecord
  belongs_to :bed
  belongs_to :product
  belongs_to :vegetable_variet
  self.belongs_to_required_by_default = false
end
