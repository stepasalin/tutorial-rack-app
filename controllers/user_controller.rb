# frozen_string_literal: true

require 'redis'
require 'json'
require_relative '../helpers/redis_helper'
require_relative '../models/user'
require_relative '../views/user_view'

class UserController
  def new_user(req)
    user = nil
    begin
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
      [500, {}, ['internal server error']]
    end
  end

  def find_user(req)
    name = req.path.gsub('/user/', '')
    user = User.find_by_name name
    UserView.new(user).render
  end
end
