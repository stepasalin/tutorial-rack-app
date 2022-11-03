require 'rack'
require 'pry'
require 'json'
require_relative 'controllers/user'

run do |env|
  req = Rack::Request.new(env)

  if req.post? && req.path == "/user/data"
    UserController.new(req).create_user
  elsif req.get? && req.path.start_with?('/user/data/')
    UserController.new(req).get_user
  elsif req.delete? && req.path.start_with?('/user/data/')
    UserController.new(req).delete_user
  elsif req.put? && req.path.start_with?('/user/data/')
    UserController.new(req).update_user
  end

end




# Валидации на User
# name может быть строкой от 1 до 30 символов латиницей без пробелов
# gender всего 3 возможных значения :f, :m, :nb
# age - integer от 0 до скольких угодно. Возраст человека В СЕКУНДАХ

# User-ы хранятся в redis в виде JSON с вышеуказанными полями

# написать маршрут, который по POST /new_user принимает JSON
# и если все валидации проходят, то кладет его в redis по ключу name
# если валидации не проходят, то необходимо вернуть http-статус 422 и все человеко-читаемым текстом
# если валидации проходят, но ключ уже занят, вернуть 409 и объяснение, что ключ уже занят
# если все проходит, вернуть 201.
# написать маршрут, который по GET /user/name отобразит HTML-страницу
# требования:
# фон синий если юзер мальчик, розовый если девочка, серый если не определился
# отобразить (дизайнерствуйте сами) как юзера зовут и его возраст в формате 
# "столько-то лет, столько-то месяцев, столько-то дней". 
# для удобства будем считать, что в каждом году 365 дней, а в каждом месяце - 30
# добавить elseif обеспечить возможность при помощи post че-то положить в БД

