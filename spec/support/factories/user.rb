# frozen_string_literal: true

require_relative '../../../app/models/user'

class UserFactory

  def self.create_user(name: nil, gender: nil, age: nil)
    user = generate_user name: name, gender: gender, age: age
    user.save
    user
  end

  def self.generate_user(name: nil, gender: nil, age: nil)
    User.new name || random_string,
             gender || random_user_gender,
             age || random_age_in_seconds
  end
end
