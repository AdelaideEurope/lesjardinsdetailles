class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one_attached :photo
  has_many :user_events
  has_many :user_presence_periods
  has_many :events, through: :user_events
  has_many :presence_periods, through: :user_presence_periods

  belongs_to :farm

  extend FriendlyId
  friendly_id :nickname, use: :slugged

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  def displayed_name
    if self.first_name == "Bras"
      "Help"
    elsif self.nickname.nil?
      self.first_name.capitalize
    else
      self.nickname.capitalize
    end
  end

  def emoji
    if self.first_name == "Bras"
      "🙏🏻"
    elsif !self.worker
      ""
    elsif self.gender == "F"
      "👩🏼‍🌾"
    else
      "👨🏻‍🌾"
    end
  end

  def initial
    if self.first_name == "Bras"
      "🙏🏻"
    else
      self.first_name[0].capitalize
    end
  end

  def is_client?
    !self.worker
  end

  def tasks_this_week
    self.events.where("farm_id = ? AND (date BETWEEN ? AND ?)", 1, Date.today.beginning_of_week, Date.today.end_of_week)
  end
end
