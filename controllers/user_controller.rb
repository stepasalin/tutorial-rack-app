# frozen_string_literal: true

require 'redis'
require 'json'
require_relative '../helpers/redis_helper'

class UserController
  def new_user(req)
    user = JSON.parse(req.body, object_class: User)
    save_result = user.save
    [201, {}, [save_result]]
  rescue JSON::ParseError
    [500, {}, ['internal server error']]
  rescue UnprocessableUserError
    [422, {}, user.validation_errors]
  rescue UserNameAlreadyTakenError
    [409, {}, ['user name already taken']]
  end

  def find_user(req)
    name = req.path.gsub('/user/', '')
    user = User.find_by_name name
    # todo to view
    [404, {}, ['user not found']] if user.nil?
    [200, {}, [user.to_json]]
  end
end
