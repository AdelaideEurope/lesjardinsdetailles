class Invoice < ApplicationRecord
  belongs_to :outlet
  has_many :sales

  def is_sent?
    self.sent == true
  end
end
