require 'rack'
require 'pry'
require 'json'
require 'redis'
require_relative 'helpers/router'
require_relative 'middlewares/errors_catcher'

class Application
  def call(env)
    ErrorsCatcher.new(
      Router.new(
        Rack::Request.new(env)
      )
    ).handle
  end
end