require_relative '../models/user'

class UserController
  attr_accessor :request

  def initialize(request)
    @request = request
  end

  def create_user
    body = JSON.parse(request.body.read)
    user = User.new(body)
    create_response(user)
  end


  def get_user
    user_name = request.path.gsub('/user/data/','')
    get_user_response(user_name)
  end


  def delete_user
    user_name = request.path.gsub('/user/data/','')
    delete_user_response(user_name)
  end


  def create_response(user)
    begin
      [201, {}, [user.save]]
    rescue UserInvalidError
      [422, {}, user.errors]
    rescue AccessKeyError
      [409, {}, ["User #{user.name} is used already"]]
    end
  end


  def get_user_response(user_name)
    begin
      [200, {}, [User.find(user_name).to_json]]
    rescue KeyExistingdError
      [404, {}, ["The key '#{user_name}' is not exist"]]
    rescue UserInvalidError
      [422, {}, errors]
    end
  end


  def delete_user_response(user_name)
    begin
      [202, {}, [User.delete(user_name)]]
    rescue KeyExistingdError
      [404, {}, ["The key '#{user_name}' is not exist"]]
    end
  end

end