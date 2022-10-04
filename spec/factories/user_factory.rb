require_relative '../test_helpers/randomizer'
class UserFactory
  def self.create(gender: nil, age: nil)
    name = gen_random_string

    user = User.new(name, 
      gender || gen_random_gender,
      age || gen_random_age)
    user.save
  end
end
