class Sale < ApplicationRecord
  belongs_to :outlet
  has_many :sales_lines

  def has_comment?
    !self.comment.nil? && !self.comment.empty?
  end
end
