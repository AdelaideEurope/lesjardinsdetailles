class Farm < ApplicationRecord
  has_many :users
  has_many :products
  has_many :gardens
  has_many :events
  has_many :outlets
  has_many :hen_actions
  has_many :sales, through: :outlets

  def workers
    self.users.where(worker: true).map{ |worker| worker }.sort_by(&:first_name)[1..-1]
  end

  def clients
    self.users.where(worker: false).map{ |worker| worker }
  end
end
