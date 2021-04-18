class Sale < ApplicationRecord
  belongs_to :outlet
  belongs_to :invoice, optional: true
  has_many :sales_lines
  has_many :baskets
  has_one :delivery_slip
  has_many :payments

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


  def has_payments?
    self.has_invoice? && !self.invoice.payments.nil? && !self.invoice.payments.empty?
  end

  def amount_paid
    total_paid = 0
    if self.has_payments?
      self.invoice.payments.each do |payment|
        total_paid += payment.paid_amount
      end
      ht_total = self.invoice.ht_total.nil? ? 0 : self.invoice.ht_total
    else
      total_paid
    end
  end

  def is_paid?
    total_paid = 0
    if self.has_invoice? && self.has_payments?
      self.invoice.payments.each do |payment|
        total_paid += payment.paid_amount
      end
      ht_total = self.invoice.ht_total.nil? ? 0 : self.invoice.ht_total
      total_paid >= ht_total
    else
      false
    end
  end

end
