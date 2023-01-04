# frozen_string_literal: true

class UserController
  def initialize(request)
    @req = request
  end

  def set_user_info
    @original_req_body = @req.body.read
    @parsed_req_body = JSON.parse(@original_req_body)
    @user = User.new(@parsed_req_body)
  end

  def create
    set_user_info
    @user.create
    [201, {}, ['new user is created!']]
  rescue InvalidInputError
    [422, {}, @user.errors]
  rescue DuplicatedUserError
    [409, {}, ['User is already created']]
  end

  def read
    name = @req.path.gsub('/user/', '').downcase
    User.find(name)
  end

  def update
    set_user_info
    @user.update
    [200, {}, ['User is updated!']]
  rescue InvalidInputError
    [422, {}, @user.errors]
  rescue UserEntityIsNotFound
    [404, {}, ['User is not found']]
  end

  def delete
    name = @req.path.gsub('/user/', '').downcase
    User.delete(name)
    [204, {}, []]
  rescue UserEntityIsNotFound
    [404, {}, ['User is not found']]
  end

  # looks terrible in postman responce. all keys are a one word mess without spaces. How to solve it>?
  def all_users_list
    [200, {}, User.list]
  end
end
