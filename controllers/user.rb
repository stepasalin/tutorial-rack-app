# frozen_string_literal: true

require 'redis'
require 'json'
require_relative '../helpers/redis'
require_relative '../models/user'
require_relative '../views/user'
require_relative '../helpers/http_errors'

class UserController
  def new_user(req)
    json = JSON.parse req.body.read
    user = User.json_create json
    save_result = user.save
    [201, {}, [save_result]]
  rescue UnprocessableUserError
    [422, {}, [user.validation_errors.to_s]]
  rescue UserNameAlreadyTakenError
    [409, {}, ['user name already taken']]
  rescue StandardError => e
    puts e.full_message
    internal_server_error
  end

  def find_user(req)
    name = req.path.gsub('/user/', '')
    user = User.find_by_name name
    doc = UserView.new(user).render
    [200, {}, [doc]]
  rescue UserNotFoundError
    [404, {}, ['User not found']]
  rescue UnprocessableUserError
    [500, {}, ['Saved user have invalid format']]
  rescue StandardError => e
    puts e.full_message
    internal_server_error
  end
end
