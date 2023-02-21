# frozen_string_literal: true

def convert_to_ymd_format(age_in_seconds)
  return 'undefined age' if age_in_seconds.nil?

  age = Time.at age_in_seconds
  zero_time = Time.at 0

  years = age.year - zero_time.year
  months = age.month - zero_time.month
  days = age.day - zero_time.day

  "#{years} years, #{months} months, #{days} days old"
end

def page_color(user_gender)
  colors = {
    m: 'DeepSkyBlue',
    f: 'DeepPink',
    nb: 'Lavender'
  }
  colors[user_gender]
end
