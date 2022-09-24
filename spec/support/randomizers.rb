# frozen_string_literal: true

require_relative '../../app/models/user'

def random_string(len = 10)
  ('a'..'z').to_a.sample(len).join
end

def random_user_gender
  User::GENDERS[rand(0..User::GENDERS.size - 1)]
end

# 51_840_000 = 20 years
def random_age_in_seconds(max = 51_840_000)
  rand max
end
