class LastPrice < ApplicationRecord
  belongs_to :product
  belongs_to :outlet
end
