class Product < ApplicationRecord
  belongs_to :farm
  belongs_to :product_group, optional: true
  has_one_attached :photo
end
