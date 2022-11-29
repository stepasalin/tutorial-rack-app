class ApplicationResponse
  def initialize(response)
    @response = response
  end


  def status
    @response[0]
  end


  def body
    @response[2][0]
  end
end



class Environment
  def initialize(app)
    @app = app
  end


  def simulate_request(method, path, body)
    response = @app.call({
      "REQUEST_METHOD" => method,
      "PATH_INFO" => path,
      "rack.input" => StringIO.new(body)
      })

    ApplicationResponse.new(response)
  end
end