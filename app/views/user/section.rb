# frozen_string_literal: true

def user_section(user)
  age = user.readable_age
  "<div>
    <p>name: #{user.name}</p>
    <p>gender: #{user.gender}</p>
    <p>years: #{age[:years]}, months: #{age[:months]},  days: #{age[:days]}</p>
  </div>"
end
