class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one_attached :photo
  has_many :user_events
  has_many :user_presence_periods

  belongs_to :farm

  extend FriendlyId
  friendly_id :nickname, use: :slugged

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
