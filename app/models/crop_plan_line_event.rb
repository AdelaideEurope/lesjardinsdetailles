class CropPlanLineEvent < ApplicationRecord
  belongs_to :crop_plan_line
  has_many :crop_plan_line_user_events
  has_one :product, through: :crop_plan_line
  has_one :bed, through: :crop_plan_line
  has_many :users, through: :crop_plan_line_user_events

  def is_done?
    !self.date_done.nil?
  end

  def done_not_done_color(date_params)
    if !self.date_done.nil?
      'olive'
    else
      'green'
    end
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

  def seedling_surface
    if self.crop_plan_line.meter_count == 30 || self.crop_plan_line.meter_count.nil?
      ""
    elsif self.crop_plan_line.meter_count == 15
      "⚠️ 1/2 planche"
    else
      "#{(self.crop_plan_line.meter_count*100)/30} %"
    end
  end

  def self.week_planting(params)
    if params.nil?
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "plantation", Date.today.beginning_of_week, Date.today.end_of_week).includes(:product, bed: [:garden]).sort_by(&:id)
    else
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "plantation", Date.parse(params).beginning_of_week, Date.parse(params).end_of_week).includes(crop_plan_line: [product: [:product_group, :photo_attachment]]).sort_by(&:id)
    end
  end

  # def self.week_harvesting(params)
  #   if params.nil?
  #     start_harvesting = self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "début récolte", Date.today.beginning_of_week, Date.today.end_of_week).includes(:product, bed: [:garden]).sort_by(&:id)
  #     crop_plan_lines = start_harvesting.map{|cple| cple.crop_plan_line_id}
  #     self.where("name = ? AND crop_plan_line_id IN (?)", "fin récolte", crop_plan_lines).includes(:product, bed: [:garden]).sort_by(&:id)
  #   else
  #     start_harvesting = self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "début récolte", Date.parse(params).beginning_of_week, Date.parse(params).end_of_week).includes(:product, bed: [:garden]).sort_by(&:id)
  #     crop_plan_lines = start_harvesting.map{|cple| cple.crop_plan_line_id}
  #     self.where("name = ? AND crop_plan_line_events.crop_plan_line_id IN (?)", "fin récolte", crop_plan_lines).includes(:product, bed: [:garden]).sort_by(&:id)
  #   end
  # end

  def self.week_bed_preparation_1_week(params)
    if params.nil?
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "préparation planche", Date.today.beginning_of_week - 1.week, Date.today.end_of_week - 1.week).includes(:product, bed: [:garden]).sort_by(&:id)
    else
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "préparation planche", Date.parse(params).beginning_of_week - 1.week, Date.parse(params).end_of_week - 1.week).includes(crop_plan_line: [product: [:product_group, :photo_attachment]]).sort_by(&:id)
    end
  end

  def self.week_bed_preparation_2_weeks(params)
    if params.nil?
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "préparation planche", Date.today.beginning_of_week, Date.today.end_of_week).includes(:product, bed: [:garden]).sort_by(&:id)
    else
      self.where("name = ? AND (date_planned BETWEEN ? AND ?)", "préparation planche", Date.parse(params).beginning_of_week, Date.parse(params).end_of_week).includes(crop_plan_line: [product: [:product_group, :photo_attachment]]).sort_by(&:id)
    end
  end
end
