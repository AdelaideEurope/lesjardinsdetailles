class Event < ApplicationRecord
  belongs_to :farm
  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events

  def is_done?
    (self.event_category == "garden" || self.event_category == "admin") && !self.date_done.nil?
  end

  def subcategory_color
    if self.event_subcategory == "rdv"
      "teagreen"
    elsif self.event_subcategory == "vente"
      "greensheen"
    end
  end

  def has_comment?
    !self.comment.nil? && !self.comment.empty?
  end

  def has_details?
    !self.details.nil? && !self.details.empty?
  end

  def has_users?
    !self.users.nil? && !self.users.empty?
  end

  def has_multiple_users?
    self.users&.length > 1
  end

  def is_user?(user)
    self.users.include?(user)
  end

  def user_event(user_id)
    UserEvent.where(user_id: user_id, event_id: self.id)[0]
  end

  def self.garden_events(params)
    if params.nil?
      Event.where("farm_id = ? AND event_category = ? AND (date BETWEEN ? AND ?)", 1, "garden", Date.today.beginning_of_week, Date.today.end_of_week)
    else
      Event.where("farm_id = ? AND event_category = ? AND (date BETWEEN ? AND ?)", 1, "garden", Date.parse(params).beginning_of_week, Date.parse(params).end_of_week)
    end
  end

  def self.admin_events(params)
    if params.nil?
      Event.where("farm_id = ? AND event_category = ? AND (date BETWEEN ? AND ?)", 1, "admin", Date.today.beginning_of_week, Date.today.end_of_week)
    else
      Event.where("farm_id = ? AND event_category = ? AND (date BETWEEN ? AND ?)", 1, "admin", Date.parse(params).beginning_of_week, Date.parse(params).end_of_week)
    end
  end
end
