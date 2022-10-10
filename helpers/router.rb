# frozen_string_literal: true

require_relative '../controllers/user'
require_relative 'http_errors'

class Router
  def initialize(req)
    @req = req
    @user_controller = UserController.new
  end

  def handle
    sleep rand(1..5)
    if @req.path == '/api/new_user' && @req.post?
      @user_controller.new_user(@req)
    elsif @req.path.start_with?('/user/')
      case @req.request_method
      when 'PUT'
        @user_controller.update_user(@req)
      when 'DELETE'
        @user_controller.delete_user(@req)
      when 'GET'
        @user_controller.find_user(@req)
      else
        route_not_found @req
      end
    elsif @req.path.start_with?('/raw_user/')
      case @req.request_method
      when 'GET'
        @user_controller.raw_user(@req)
      end
    elsif @req.request_method == 'GET' && @req.path == '/all_user_names'
      @user_controller.all_user_names
    else
      route_not_found @req
    end
  end
end
