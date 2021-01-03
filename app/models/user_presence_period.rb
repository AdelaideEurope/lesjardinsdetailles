class UserPresencePeriod < ApplicationRecord
  belongs_to :user
  belongs_to :presence_period
end
