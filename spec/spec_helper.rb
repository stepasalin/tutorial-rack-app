class Environment
  def initialize(app)
    @app = app
  end

  def simulate_request(method, path, body)
    @app.call({
      "REQUEST_METHOD" => method,
      "PATH_INFO" => path,
      'rack.input' => StringIO.new(body)
    })
  end
end