# frozen_string_literal: true

ZERO_TIME = (Time.at 0).freeze

def born_timestamp_to_year_month_day(timestamp)
  now = Time.at timestamp
  {
    years: now.year - ZERO_TIME.year,
    months: now.month - ZERO_TIME.month,
    days: now.day - ZERO_TIME.day
  }
end
