class Basket < ApplicationRecord
  belongs_to :sale
  has_many :basket_lines

  def has_basket_lines?
    !self.basket_lines.nil? && !self.basket_lines.empty?
  end
end
