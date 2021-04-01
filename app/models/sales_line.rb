class SalesLine < ApplicationRecord
  belongs_to :bed, optional: true
  belongs_to :product
  belongs_to :sale
end
