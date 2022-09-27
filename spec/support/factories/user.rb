# frozen_string_literal: true

require_relative '../../../app/models/user'

class UserFactory

  def self.create_user(user_sample = nil)
    user = generate_user user_sample
    user.save
    user
  end

  def self.generate_user(user_sample = nil)
    User.new user_sample&.dig(:name) || random_string,
             user_sample&.dig(:gender) || random_user_gender,
             user_sample&.dig(:age) || random_age_in_seconds
  end
end
