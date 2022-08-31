# frozen_string_literal: true

require 'redis'
require 'json'
require_relative '../helpers/redis'
require_relative '../models/user'
require_relative '../views/user'
require_relative '../helpers/http_errors'

class UserController
  def new_user(req)
    user = bind_user req
    save_result = user.save
    [201, {}, [save_result]]
  end

  def find_user(req)
    name = bind_user_name req
    user = User.find_by_name name
    doc = UserView.new(user).render
    [200, {}, [doc]]
  end

  private

  def bind_user(req)
    json = JSON.parse req.body.read
    User.json_create json
  end

  def bind_user_name(req)
    req.path.gsub('/user/', '')
  end
end
