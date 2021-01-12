class Outlet < ApplicationRecord
  belongs_to :outlet_group
  belongs_to :farm
end
