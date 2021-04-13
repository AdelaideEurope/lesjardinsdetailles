class BasketLine < ApplicationRecord
  belongs_to :basket
  belongs_to :bed, optional: true
  belongs_to :product
end
