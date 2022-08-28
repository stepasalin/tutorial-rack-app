# frozen_string_literal: true

require_relative '../controllers/user'

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
      not_found
    end
  end

  def not_found
    [404, {}, ["Sorry, dunno what to do about #{@req.request_method} #{@req.path}"]]
  end
end
