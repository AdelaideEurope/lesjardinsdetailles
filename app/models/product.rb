class Product < ApplicationRecord
  belongs_to :farm
  belongs_to :product_group

  has_many :vegetable_variets
  has_many :crop_plan_lines

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_one_attached :photo
end
