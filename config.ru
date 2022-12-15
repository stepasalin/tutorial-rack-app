# frozen_string_literal: true

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
    key = req.path.gsub('/user/', '')
    value = REDIS_CONNECTION.get(key) || ''
    [200, {}, [value]]
  elsif req.post? && req.path.start_with?('/user/new/')
    original_req_body = req.body.read
    parsed_req_body = JSON.parse(original_req_body)
    value = REDIS_CONNECTION.set(parsed_req_body["name"],original_req_body) || ''
    [201, {}, ["new user is created! The nickname is #{req_body["name"]} and his age is #{req_body["age"]}"]]
  else
    [404, {}, ["Sorry, dunno what to do about #{req.request_method} #{req.path}"]]
  end
end

# Задача #0
# реализовать добавление Юзера через POST запрос,
# т.е если прислать POST на '/api/user/new' с JSON в теле,
# то этот JSON будет записан в redis по ключу, переданному в поле name
# REDIS_CONNECTION.set(key, value)


# написать маршрут, который по POST /new_user принимает JSON
# и если все валидации проходят, то кладет его в redis по ключу name
# если валидации не проходят, то необходимо вернуть http-статус 422 
# и все человеко-читаемым текстом
# если валидации проходят, но ключ уже занят,
# вернуть 409 и объяснение, что ключ уже занят

# Валидации на User
# name может быть строкой от 1 до 30 символов латиницей без пробелов
# gender всего 3 возможных значения :f, :m, :nb
# age - integer от 0 до скольких угодно. Возраст человека В СЕКУНДАХ