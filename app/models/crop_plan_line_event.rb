class CropPlanLineEvent < ApplicationRecord
  belongs_to :crop_plan_line
  has_many :crop_plan_line_user_events
  has_one :product, through: :crop_plan_line
  has_one :bed, through: :crop_plan_line
  has_many :users, through: :crop_plan_line_user_events

  def is_done?
    !self.date_done.nil?
  end

  def has_comment?
    !self.comment.nil? && !self.comment.empty?
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
    CropPlanLineUserEvent.where(user_id: user_id, crop_plan_line_event_id: self.id)[0]
  end


  def self.week_planting(params)
    if params.nil?
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "plantation", Date.today.beginning_of_week, Date.today.end_of_week).includes(:product, bed: [:garden]).sort_by(&:id)
    else
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "plantation", Date.parse(params).beginning_of_week, Date.parse(params).end_of_week).includes(crop_plan_line: [product: [:product_group, :photo_attachment]]).sort_by(&:id)
    end
  end

  def self.week_harvesting(params)
    if params.nil?
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "début récolte", Date.today.beginning_of_week, Date.today.end_of_week).includes(:product, bed: [:garden]).sort_by(&:id)
    else
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "début récolte", Date.parse(params).beginning_of_week, Date.parse(params).end_of_week).includes(crop_plan_line: [product: [:product_group, :photo_attachment]]).sort_by(&:id)
    end
  end

  def self.week_bed_preparation_1_week(params)
    if params.nil?
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "plantation", Date.today.beginning_of_week + 1.week, Date.today.end_of_week + 1.week).includes(:product, bed: [:garden]).sort_by(&:id)
    else
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "plantation", Date.parse(params).beginning_of_week + 1.week, Date.parse(params).end_of_week + 1.week).includes(crop_plan_line: [product: [:product_group, :photo_attachment]]).sort_by(&:id)
    end
  end

  def self.week_bed_preparation_2_weeks(params)
    if params.nil?
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "plantation", Date.today.beginning_of_week + 2.week, Date.today.end_of_week + 2.week).includes(:product, bed: [:garden]).sort_by(&:id)
    else
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "plantation", Date.parse(params).beginning_of_week + 2.week, Date.parse(params).end_of_week + 2.week).includes(crop_plan_line: [product: [:product_group, :photo_attachment]]).sort_by(&:id)
    end
  end
end
