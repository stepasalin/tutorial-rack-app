require 'rack'
require 'pry'
require 'json'
require_relative '../controllers/user'


class Application
  def call(env)
    req = Rack::Request.new(env)
    sleep rand(3..5)

    if req.post? && req.path == "/user/data"
      UserController.new(req).create_user
    elsif req.get? && req.path.start_with?('/user/data/')
      UserController.new(req).get_user
    elsif req.delete? && req.path.start_with?('/user/data/')
      UserController.new(req).delete_user
    elsif req.put? && req.path.start_with?('/user/data/')
      UserController.new(req).update_user
    elsif req.get? && req.path.start_with?('/user/html/')
      UserController.new(req).get_html
    elsif req.get? && req.path == '/all_user_names'
      UserController.new(req).get_all_user_names
    end
  end
end