class Sale < ApplicationRecord
  belongs_to :outlet
  has_many :sales_lines
  has_many :baskets

  def has_comment?
    !self.comment.nil? && !self.comment.empty?
  end

  def has_baskets?
    !self.baskets.nil? && !self.baskets.empty?
  end
end
