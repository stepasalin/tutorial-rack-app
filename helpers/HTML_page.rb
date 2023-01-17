# frozen_string_literal: true

def convert_to_ymd_format(age_in_seconds)
  return 'undefined age' if age_in_seconds.nil?

  years = (age_in_seconds / 31_536_000).floor
  months = (age_in_seconds / 2_628_288).floor - (years * 12)
  days = (age_in_seconds / 86_400).floor - (years * 365) - (months * 12)
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
