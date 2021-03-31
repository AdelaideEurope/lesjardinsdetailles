class Decision < ApplicationRecord
  belongs_to :farm

  def has_comment?
    !self.comment.nil? && !self.comment.empty?
  end
end
