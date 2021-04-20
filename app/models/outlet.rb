class Outlet < ApplicationRecord
  belongs_to :outlet_group
  belongs_to :farm
  has_many :sales
  has_many :baskets, through: :sales
  has_many :invoices
  has_many :payments

  has_one_attached :photo

end
