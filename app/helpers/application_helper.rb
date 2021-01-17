module ApplicationHelper
  def get_price_in_cents(price)
    number_to_currency(price.to_i.fdiv(100))
  end

  def show_replace_nil_with_dash(value)
    if value.nil?
      return "-"
    end
  end

  def remove_trailing_zero(num)
    if !num.nil? && num.to_i - num == 0.to_f
      num.to_i
    else num
    end
  end

  def remove_leading_zero(num)
    if num[0] == "0"
      num[1..-1]
    end
  end

  def get_elapsed_days_since_beginning_of_year(date_to_number_days)
    ((date_to_number_days * 100) / 365).to_i
  end

  # def percentage_number_days_between_two_dates(start, end)
  #   ((number_days_since_first_day_of_year * 100) / 365).to_i
  # end
end
