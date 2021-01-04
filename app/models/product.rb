class Product < ApplicationRecord
  belongs_to :farm
  belongs_to :product_group

  has_many :crop_plan_lines

  has_one_attached :photo
end
