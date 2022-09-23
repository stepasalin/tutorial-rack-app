# frozen_string_literal: true

require_relative '../../../app/models/user'

def random_string(len = 10)
  ('a'..'z').to_a.sample(len).join
end

def random_gender
  User::GENDERS[rand(0..User::GENDERS.size - 1)]
end

# 51_840_000 = 20 years
def random_age_in_seconds(max = 51_840_000)
  rand max
end

def valid_user
  User.new random_string, random_gender, random_age_in_seconds
end

def invalid_user
  User.new '', :lol, -10
end

def too_long_name
  User.new random_string(100), :m, 10
end

PROPERTIES = {
  valid: method(:valid_user),
  full_invalid: method(:invalid_user),
  too_long_name: method(:too_long_name)
}.freeze

def create_user(property, with_saving: false)
  user = PROPERTIES[property].call
  user.save if with_saving
  user
end
