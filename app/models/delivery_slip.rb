class DeliverySlip < ApplicationRecord
  belongs_to :sale

  def is_confirmed?
    self.confirmed == true
  end
end
