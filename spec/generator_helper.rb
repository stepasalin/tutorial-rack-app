require_relative '../models/user'

class UserGenerator
    def self.generate(name: nil, age: nil, gender: nil)
    user_name = name || Array.new(rand(1..30)) { [*"A".."Z", *"a".."z", *"0".."9"].sample }.join
    user_gender = gender || [:m, :f, :nb].sample
    user_age = age || rand(1..3153600000)

    random_user_params = {"name" => user_name, "gender" => user_gender, "age" => user_age}

    User.new(random_user_params)
  end


  def self.create(name: nil, age: nil, gender: nil)
    user = generate(name:, age:, gender:)
    user.save
    user
  end


  def self.overlong_user_name
    user_name = Array.new(31) { [*"A".."Z", *"a".."z", *"0".."9"].sample }.join
    user_gender = [:m, :f, :nb].sample
    user_age = rand(1..3153600000)

    random_user_params = {"name" => user_name, "gender" => user_gender, "age" => user_age}

    User.new(random_user_params)
  end





  def self.overlong_user_name
    user_name = Array.new(rand(1..30)) { [*"A".."Z", *"a".."z", *"0".."9", *""].sample }.join
    user_gender = [:m, :f, :nb].sample
    user_age = rand(1..3153600000)

    random_user_params = {"name" => user_name, "gender" => user_gender, "age" => user_age}

    User.new(random_user_params)
  end

end