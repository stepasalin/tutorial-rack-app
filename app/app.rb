class Application
  def call(env)
    ErrorsCatcher.new(
      Router.new(
        Rack::Request.new(env)
      )
    ).handle
  end
end
