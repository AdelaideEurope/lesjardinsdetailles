class Invoice < ApplicationRecord
  belongs_to :outlet
  has_many :sales
  has_many :payments

  def is_sent?
    self.sent == true
  end
end
