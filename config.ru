require 'rack'
require 'pry'
require 'json'
require 'redis'
require_relative 'helpers/redis_helper'

run do |env|
  req = Rack::Request.new(env)
  if req.post? && req.path == '/epic-post'
    req_body = JSON.parse(req.body.read)
    [200, {}, ["epic post detected! The body is #{req_body}"]]
  elsif req.get? && req.path == '/epic-get'
    [200, {}, ['epic get detected!']]
  elsif req.get? && req.path.start_with?('/user/')
    key = req.path.gsub('/user/','')
    value = REDIS_CONNECTION.get(key) || ''
    binding.pry
    [200, {}, [value]]
  else
    [404,{}, ["Sorry, dunno what to do about #{req.request_method} #{req.path}"]]
  end
end

# Задача #0
# реализовать добавление Юзера через POST запрос,
# т.е если прислать POST на '/api/user/new' с JSON в теле,
# то этот JSON будет записан в redis по ключу, переданному в поле name
# REDIS_CONNECTION.set(key, value)



