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
    [200, {}, [value]]
  else
    [404,{}, ["Sorry, dunno what to do about #{req.request_method} #{req.path}"]]
  end
end

# Валидации на User
# name может быть строкой от 1 до 30 символов латиницей без пробелов
# gender всего 3 возможных значения :f, :m, :nb
# age - integer от 0 до скольких угодно. Возраст человека В СЕКУНДАХ

# данные хранятся в redis

# написать маршрут, который по POST /new_user принимает JSON
# и если все валидации проходят, то кладет его в redis по ключу name
# если валидации не проходят, то необходимо вернуть http-статус 422 и все человеко-читаемым текстом
# если валидации проходят, но ключ уже занят, вернуть 409 и объяснение, что ключ уже занят

# написать маршрут, который по GET /user/name отобразит HTML-страницу
# требования:
# фон синий если юзер мальчик, розовый если девочка, серый если не определился
# отобразить (дизайнерствуйте сами) как юзера зовут и его возраст в формате 
# "столько-то лет, столько-то месяцев, столько-то дней". 
# для удобства будем считать, что в каждом году 365 дней, а в каждом месяце - 30




