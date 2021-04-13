class Bed < ApplicationRecord
  belongs_to :garden
  has_many :crop_plan_lines
  has_many :crop_plan_line_events
  has_many :products, through: :crop_plan_lines
  has_many :sales_lines
  has_many :basket_lines

  def self.add_full_name
    self.all.each do |bed|
      full_name = bed.garden.name + " - " + bed.name
      bed.update(full_name: full_name)
    end
  end
end
