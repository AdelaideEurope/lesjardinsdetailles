module ApplicationHelper
  def get_price_in_cents(price)
    number_to_currency(price.to_i.fdiv(100))
  end

  def show_replace_nil_with_dash(value)
    if value.nil? || value.zero?
      return "-"
    end
  end

  def remove_trailing_zero(num)
    if !num.nil? && num.to_i - num == 0.to_f
      num.to_i
    else
      num.to_s.gsub('.', ',')
    end
  end

  def remove_leading_zero(num)
    if num[0] == "0"
      num[1..-1]
    end
  end


  def find_day_correspondence(num)
    days = (1..365).to_a
    day_correspondences = {}
    days.each {|day| day_correspondences[day] = day*100.fdiv(365)}
    day_correspondences[num]
  end


  def percentage(value1, value2)
    (value1*100)/value2
  end

  def plural(value, sing, plural)
    if value.nil?
      sing
    elsif value > 1
      plural
    else
      sing
    end
  end

  # def percentage_number_days_between_two_dates(start, end)
  #   ((number_days_since_first_day_of_year * 100) / 365).to_i
  # end
end
