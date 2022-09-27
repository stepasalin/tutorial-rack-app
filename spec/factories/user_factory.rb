require_relative '../test_helpers/gen_random_params'
class UserFactory
  def self.create
    name = gen_random_string(30)
    gender = gen_random_gender
    age = gen_random_age

    user = User.new(name, gender, age)
    user.save
  end
end