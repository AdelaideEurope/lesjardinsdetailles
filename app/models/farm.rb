class Farm < ApplicationRecord
  has_many :users
  has_many :products
  has_many :gardens
end