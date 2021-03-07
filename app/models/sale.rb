class Sale < ApplicationRecord
  belongs_to :outlet

  def has_comment?
    !self.comment.nil? && !self.comment.empty?
  end
end
