class Payment < ApplicationRecord
  belongs_to :outlet
  belongs_to :invoice
end
