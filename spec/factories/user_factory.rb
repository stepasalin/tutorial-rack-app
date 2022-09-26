class UserFactory
  attr_reader :name, :gender, :age
  def self.create
    @name = 'TestName'
    @gender = 'fm'
    @age = 123123211

    user = User.new(@name, @gender, @age)
    user.save
    # TODO сделать чтоб user.save возвращал юзера
    { 'name' => @name, 'gender' => @gender, 'age' => @age }
  end
end