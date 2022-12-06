require_relative '../models/user'

class UserGenerator
  def self.generate(traits=[], name: nil, age: nil, gender: nil)
    user_name = name || name_generator
    user_gender = gender || [:m, :f, :nb].sample
    user_age = age || rand(1..3153600000)

    if traits.include? :overlong_name
      user_name = name_generator(31)
    end
    if traits.include? :forbidden_name_symbol
      user_name = name_generator(29) + [*" ".."/", *"[".."'", *":".."?", *"{".."~"].sample
    end
    if traits.include? :wrong_user_gender
      user_gender = Array.new(rand(1..2)) { [*"a", *"c".."e", *"g".."l", *"n".."z"].sample}.join.to_sym
    end

    random_user_params = {"name" => user_name, "gender" => user_gender, "age" => user_age}

    User.new(random_user_params)
  end


  def self.create(traits=[],name: nil, age: nil, gender: nil)
    user = generate(traits, name: name, age: age, gender: gender)
    user.save
    user
  end


  def self.name_generator(length=rand(1..30))
    Array.new(length) { [*"A".."Z", *"a".."z", *"0".."9"].sample }.join
  end
end