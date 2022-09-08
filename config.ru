require 'rack'
require 'pry'
require 'json'
require 'redis'
require_relative 'helpers/redis_helper'
require_relative 'helpers/tools'
require_relative 'models/user'
require_relative 'controllers/user_controller'
require_relative 'views/user_view'

class ArgumentsError < StandardError
end

class ExistingError < StandardError
end

run do |env|
  req = Rack::Request.new(env)
  user_controller = UserController.new(req)
  if req.post? && req.path == '/new_user'
    user_controller.save_user
  elsif req.get? && req.path.start_with?('/user/')
    user_controller.user_page_get
  elsif req.put? && req.path == '/edit_user'
    user_controller.edit_user
  elsif req.delete? && req.path == '/delete_user'
    user_controller.user_delete
  else
    [404, {}, ["Sorry, dunno what to do about #{req.request_method} #{req.path}"]]
  end
end
