# frozen_string_literal: true

require_relative '../../helpers/time'

def user_section(user)
  age = born_timestamp_to_year_month_day user.age
  "<div>
    <p>name: #{user.name}</p>
    <p>gender: #{user.gender}</p>
    <p>years: #{age[:years]}, months: #{age[:months]},  days: #{age[:days]}</p>
  </div>"
end
