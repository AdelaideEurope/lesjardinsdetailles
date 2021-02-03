class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one_attached :photo
  has_many :user_events
  has_many :user_presence_periods
  has_many :crop_plan_line_user_event
  has_many :events, through: :user_events
  has_many :presence_periods, through: :user_presence_periods
  has_many :crop_plan_line_events, through: :crop_plan_line_user_event

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

  def is_female?
    self.gender == "F"
  end

  def is_client?
    !self.worker
  end

  def events_this_week(date_params)
    if date_params.nil?
      self.events.where("((date BETWEEN ? AND ?) OR (start_time BETWEEN ? AND ?)) AND event_category != ?", Date.today.beginning_of_week, Date.today.end_of_week + 1.week, Date.today.beginning_of_week, Date.today.end_of_week + 1.week, 'garden')
    else
      self.events.where("((date BETWEEN ? AND ?) OR (start_time BETWEEN ? AND ?)) AND event_category != ?", Date.parse(date_params).beginning_of_week, Date.parse(date_params).end_of_week + 1.week, Date.parse(date_params).beginning_of_week, Date.parse(date_params).end_of_week + 1.week, 'garden')
    end
  end

  def garden_tasks_this_week(date_params)
    if date_params.nil?
      self.crop_plan_line_events.includes(crop_plan_line: [:product, :bed]).where("(date_planned BETWEEN ? AND ?)", Date.today.beginning_of_week, Date.today.end_of_week + 1.week)
    else
      self.crop_plan_line_events.includes(crop_plan_line: [:product, :bed]).where("(date_planned BETWEEN ? AND ?)", Date.parse(date_params).beginning_of_week, Date.parse(date_params).end_of_week + 1.week)
    end
  end

  def garden_events_this_week(date_params)
    if date_params.nil?
      self.events.where("((date BETWEEN ? AND ?) OR (start_time BETWEEN ? AND ?)) AND event_category = ?", Date.today.beginning_of_week, Date.today.end_of_week + 1.week, Date.today.beginning_of_week, Date.today.end_of_week + 1.week, 'garden')
    else
      self.events.where("((date BETWEEN ? AND ?) OR (start_time BETWEEN ? AND ?)) AND event_category = ?", Date.parse(date_params).beginning_of_week, Date.parse(date_params).end_of_week + 1.week, Date.parse(date_params).beginning_of_week, Date.parse(date_params).end_of_week + 1.week, 'garden')
    end
  end

  def late_garden_tasks(date_params)
    if date_params.nil?
      self.crop_plan_line_events.includes(crop_plan_line: [:product, :bed]).where("date_planned < ? AND date_done IS NULL", Date.today.beginning_of_week)
    else
      self.crop_plan_line_events.includes(crop_plan_line: [:product, :bed]).where("date_planned < ? AND date_done IS NULL", Date.parse(date_params).beginning_of_week)
    end
  end
end
