class SalesLine < ApplicationRecord
  belongs_to :bed
  belongs_to :product
  belongs_to :sale
end
