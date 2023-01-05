# frozen_string_literal: true

require 'rack'
require 'pry'
require 'json'
require 'redis'
require_relative 'models/user'
require_relative 'helpers/redis_helper'
require_relative 'controllers/user'

run do |env|
  req = Rack::Request.new(env)
  controller = UserController.new(req)
  if req.post? && req.path.start_with?('/user/new')
    controller.create
  elsif req.get? && req.path.start_with?('/user')
    controller.read
  elsif req.post? && req.path.start_with?('/user/update')
    controller.update
  elsif req.delete? && req.path.start_with?('/user')
    controller.delete
  elsif req.get? && req.path.start_with?('/get_users')
    controller.all_users_list
  else
    [404, {}, ["Sorry, dunno what to do about #{req.request_method} #{req.path}"]]
  end
end
