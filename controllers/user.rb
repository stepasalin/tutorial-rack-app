require_relative '../models/user'
require_relative '../views/user'

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


  def get_html
    user_name = request.path.gsub('/user/html/', '')
    get_user_html_response(user_name)
  end


  def delete_user
    user_name = request.path.gsub('/user/data/','')
    delete_user_response(user_name)
  end


  def update_user
    user_name = request.path.gsub('/user/data/','')
    body = JSON.parse(request.body.read)
    updated_user = User.new(body)
    update_user_response(user_name, updated_user)
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
    rescue KeyExistingError
      [404, {}, ["The key '#{user_name}' is not exist"]]
    rescue UserInvalidError
      [422, {}, errors]
    end
  end


  def get_user_html_response(user_name)
    begin
      [200, {}, [UserView.new(User.find(user_name)).generate_html]]
    rescue KeyExistingError
      [404, {}, ["The key '#{user_name}' is not exist"]]
    rescue UserInvalidError
      [422, {}, errors]
    end
  end


  def delete_user_response(user_name)
    begin
      [202, {}, [User.delete(user_name)]]
    rescue KeyExistingError
      [404, {}, ["The key '#{user_name}' is not exist"]]
    end
  end


  def update_user_response(user_name, updated_user)
    begin
      [200, {}, [updated_user.update(user_name)]]
    rescue KeyExistingError
      [404, {}, ["The key '#{user_name}' is not exist"]]
    rescue UserNameError
      [422, {}, ["User name cannot be changed"]]
    rescue UserInvalidError
      [422, {}, updated_user.errors]
    end
  end

end