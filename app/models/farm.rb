class Farm < ApplicationRecord
  has_many :users
  has_many :products
  has_many :gardens
  has_many :events
  has_many :outlets
  has_many :sales, through: :outlets
end
