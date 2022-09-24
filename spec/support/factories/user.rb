# frozen_string_literal: true

require_relative '../../../app/models/user'

class UserFactory
  def self.create_user(save: false)
    user = User.new random_string, random_user_gender, random_age_in_seconds
    user.save if save
    user
  end
end
