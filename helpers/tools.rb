def time_convert(time)
  time = Time.at(time)
  base_time = Time.at(0)
  days = time.day - base_time.day
  months = time.month - base_time.month
  years = time.year - base_time.year

  { 'years' => years, 'months' => months, 'days' => days }
end