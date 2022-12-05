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
    user = generate(name: name, age: age, gender: gender)
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


  def self.forbidden_name_symbol
    user_name = Array.new(rand(1..29)) { [*"A".."Z", *"a".."z", *"0".."9", *""].sample }.join + [*" ".."/", *"[".."'", *":".."?", *"{".."~"].sample
    user_gender = [:m, :f, :nb].sample
    user_age = rand(1..3153600000)

    random_user_params = {"name" => user_name, "gender" => user_gender, "age" => user_age}

    User.new(random_user_params)
  end


  def self.wrong_user_gender
    user_name = Array.new(rand(1..30)) { [*"A".."Z", *"a".."z", *"0".."9", *""].sample }.join
    user_gender = Array.new(rand(1..2)) { [*"a", *"c".."e", *"g".."l", *"n".."z"].sample}.join.to_sym
    user_age = rand(1..3153600000)

    random_user_params = {"name" => user_name, "gender" => user_gender, "age" => user_age}

    User.new(random_user_params)
  end
end