class Sale < ApplicationRecord
  belongs_to :outlet
  belongs_to :invoice
  has_many :sales_lines
  has_many :baskets
  has_one :delivery_slip

  def has_comment?
    !self.comment.nil? && !self.comment.empty?
  end

  def has_baskets?
    !self.baskets.nil? && !self.baskets.empty?
  end

  def has_delivery_slip?
    !self.delivery_slip.nil?
  end

  def has_invoice?
    !self.invoice.nil?
  end

end
