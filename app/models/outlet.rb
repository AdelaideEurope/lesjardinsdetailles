class Outlet < ApplicationRecord
  belongs_to :outlet_group
  belongs_to :farm

  has_one_attached :photo

end
