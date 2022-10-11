# frozen_string_literal: true

class RackResponse
  attr_reader :status, :body

  def initialize(status, body)
    @status = status
    @body = body
  end
end

def execute_rack_request(app, request)
  response = app.call request
  RackResponse.new response[0], response[2][0]
end
