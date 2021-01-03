class PresencePeriod < ApplicationRecord
  has_many :user_presence_periods
  has_many :users, through: :user_presence_periods
end
