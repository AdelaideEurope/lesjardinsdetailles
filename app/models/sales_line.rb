class SalesLine < ApplicationRecord
  belongs_to :bed, optional: true
  belongs_to :product
  belongs_to :sale

  def has_comment?
    !self.comment.nil? && !self.comment.empty?
  end
end
