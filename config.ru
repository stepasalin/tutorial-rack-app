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
  if req.post? && req.path == '/epic-post'
    req_body = JSON.parse(req.body.read)
    [200, {}, ["epic post detected! The body is #{req_body}"]]
  elsif req.get? && req.path == '/epic-get'
    [200, {}, ['epic get detected!']]
  elsif req.get? && req.path.start_with?('/user/')
    key = req.path.gsub('/user/', '')
    value = REDIS_CONNECTION.get(key) || ''
    [200, {}, [value]]
  elsif req.post? && req.path.start_with?('/user/new/')
    controller.execute_request
    controller.send_create_response
  elsif req.post? && req.path.start_with?('/user/update/')
    controller.execute_request
    controller.send_update_response
  else
    [404, {}, ["Sorry, dunno what to do about #{req.request_method} #{req.path}"]]
  end
end
