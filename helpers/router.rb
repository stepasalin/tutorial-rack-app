# frozen_string_literal: true

require_relative '../controllers/user'
require_relative 'http_errors'

class Router
  def initialize(req)
    @req = req
    @user_controller = UserController.new
  end

  def handle
    if @req.path == '/api/new_user' && @req.post?
      @user_controller.new_user(@req)
    elsif @req.path.start_with?('/user/') && @req.get?
      @user_controller.find_user(@req)
    else
      route_not_found @req
    end
  end
end
