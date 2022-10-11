# frozen_string_literal: true

require 'redis'
require 'json'
require_relative '../models/user'
require_relative '../views/user'
require_relative '../helpers/http_errors'

class InvalidRequestError < RuntimeError; end

class UserController

  def update_user(req)
    user = bind_user req
    name = bind_user_name req
    raise InvalidRequestError, 'user name in path not equal user name in body' if user.name != name

    user.update
    [200, {}, [user.to_json]]
  end

  def delete_user(req)
    name = bind_user_name req
    user = User.delete_by_name name
    [200, {}, [user.to_json]]
  end

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

  def raw_user(req)
    name = bind_raw_user_name req
    user = User.find_by_name name
    [200,{},[user.to_json]]
  end

  def all_user_names
    #binding.pry
    [200,{},[User.all_user_names.to_json]]
  end

  private

  def bind_user(req)
    json = JSON.parse req.body.read
    User.json_create json
  end

  def bind_user_name(req)
    req.path.gsub('/user/', '')
  end

  def bind_raw_user_name(req)
    req.path.gsub('/raw_user/', '')
  end
end
