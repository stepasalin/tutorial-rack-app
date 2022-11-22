class UserGenerator
  attr_reader :user_name, :user_gender, :user_age

  def initialize
    @user_name = Array.new(rand(1..30)) { [*"A".."Z", *"a".."z", *"0".."9"].sample }.join
    @user_gender = [:m, :f, :nb].sample
    @user_age = rand(1..3153600000)
  end


  def user_data
    {"name": @user_name, "gender": @user_gender, "age": @user_age}
  end


  def user_name
    @user_name
  end


  def user_gender
    @user_gender
  end


  def user_age
    @user_age
  end
end