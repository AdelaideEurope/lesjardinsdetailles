class Garden < ApplicationRecord
  belongs_to :farm
  has_many :beds
end
