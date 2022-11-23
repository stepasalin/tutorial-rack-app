
class UserGenerator
    def self.generate
    user_name = Array.new(rand(1..30)) { [*"A".."Z", *"a".."z", *"0".."9"].sample }.join
    user_gender = [:m, :f, :nb].sample
    user_age = rand(1..3153600000)

    random_user_params = {"name" => user_name, "gender" => user_gender, "age" => user_age}

    User.new(random_user_params)
  end
end