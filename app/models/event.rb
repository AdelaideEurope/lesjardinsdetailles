class Event < ApplicationRecord
  belongs_to :farm
  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events

  def is_done?
    (self.event_category == "garden" || self.event_category == "admin") && !self.date_done.nil?
  end

  def done_not_done_color(date_params)
    if (self.event_category == "garden" || self.event_category == "admin") && !self.date_done.nil?
      'olive'
    else
      'green'
    end
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

  def formatted_date(date)
    if self.is_all_day
      date.strftime('%d/%m')
    else
      date.strftime('%d/%m à %Hh%M')
    end
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

  def self.garden_events(params, farm_id)
    if params.nil?
      self.where("farm_id = ? AND event_category = ? AND (date BETWEEN ? AND ?)", farm_id, "garden", Date.today.beginning_of_week, Date.today.end_of_week)
    else
      self.where("farm_id = ? AND event_category = ? AND (date BETWEEN ? AND ?)", farm_id, "garden", Date.parse(params).beginning_of_week, Date.parse(params).end_of_week)
    end
  end

  def self.admin_events(params, farm_id)
    if params.nil?
      self.where("farm_id = ? AND event_category = ? AND (date BETWEEN ? AND ?)", farm_id, "admin", Date.today.beginning_of_week, Date.today.end_of_week)
    else
      self.where("farm_id = ? AND event_category = ? AND (date BETWEEN ? AND ?)", farm_id, "admin", Date.parse(params).beginning_of_week, Date.parse(params).end_of_week)
    end
  end

  def self.dated_admin_events(farm_id)
    self.where("farm_id = ? AND event_category = ?", farm_id, "dated_admin")
  end
end
