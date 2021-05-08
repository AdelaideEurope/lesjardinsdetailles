class DailyEggCount < ApplicationRecord
  def self.week_egg_count(params)
    if params.nil?
      self.where("date >= ? AND date <= ?", Date.today.beginning_of_week, Date.today.end_of_week).sort_by(&:date)
    else
      self.where("date >= ? AND date <= ?", Date.parse(params).beginning_of_week, Date.parse(params).end_of_week).sort_by(&:date)
    end
  end
end
