# frozen_string_literal: true

class UserController
  def initialize(body)
    @original_req_body = body.read
    @parsed_req_body = JSON.parse(@original_req_body)
    @user = User.new(@parsed_req_body['name'], @parsed_req_body['age'], @parsed_req_body['gender'])
    @user.full_info = @original_req_body
  end

  def send_update_response
    @user.update
    [200, {}, ['User is updated!']]
  rescue InvalidInputError
    [422, {}, @user.errors]
  rescue UserEntityIsNotFound
    [404, {}, ['User is not found']]
  end

  def send_create_response
    @user.create
    [201, {}, ['new user is created!']]
  rescue InvalidInputError
    [422, {}, @user.errors]
  rescue DuplicatedUserError
    [409, {}, ['User is already created']]
  end
end
