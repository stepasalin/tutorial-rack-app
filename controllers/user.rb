# frozen_string_literal: true

require 'redis'
require 'json'
require_relative '../helpers/redis'
require_relative '../models/user'
require_relative '../views/user'

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
      internal_server_error
    end
  end

  def find_user(req)
    name = req.path.gsub('/user/', '')
    user = User.find_by_name name
    begin
      doc = UserView.new(user).render
      [200, {}, [doc]]
    rescue StandardError => e
      puts e.full_message
      internal_server_error
    end
  end

  def internal_server_error
    [500, {}, ['internal server error']]
  end
end
