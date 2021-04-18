class Payment < ApplicationRecord
  belongs_to :outlet
  belongs_to :invoice, optional: true
  belongs_to :sale, optional: true
end
