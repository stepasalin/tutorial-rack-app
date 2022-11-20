class UserGenerator
  attr_reader :user_name, :user_gender, :user_age

  def initialize
    @user_name = ''
    @user_gender = [:m, :f, :nb]
    @user_age = 0

    user_data   #?
  end


  def user_data
    {"name": user_name, "gender": user_gender,"age": user_age}
  end


  def user_name
    name_length = rand(1..30)
    @user_name = Array.new(name_length) { [*"A".."Z", *"a".."z", *"0".."9"].sample }.join
  end


  def user_gender
    @user_gender.sample
  end


  def user_age
    @user_age = rand(1..3153600000)
  end
end