# frozen_string_literal: true

def convert_to_ymd_format(age_in_seconds)
  return 'undefined age' if age_in_seconds.nil?

  years, seconds_left = age_in_seconds.divmod(60 * 60 * 24 * 365)
  months, seconds_left = seconds_left.divmod(60 * 60 * 24 * 30)
  days = seconds_left / (60 * 60 * 24)
  "#{years} years, #{months} months, #{days} days old"
end

def set_page_color
  genders = {
    m: 'DeepSkyBlue',
    f: 'DeepPink',
    nb: 'Lavender'
  }
  genders[@user.gender]
end
