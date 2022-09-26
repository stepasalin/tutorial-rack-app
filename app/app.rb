# frozen_string_literal: true

require_relative 'middlewares/errors_catcher'
require_relative 'helpers/router'
require_relative 'controllers/user'
require 'rack'

class Application
  def call(env)
    ErrorsCatcher.new(
      Router.new(
        Rack::Request.new(env)
      )
    ).handle
  end
end
