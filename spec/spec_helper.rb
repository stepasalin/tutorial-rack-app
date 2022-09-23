# frozen_string_literal: true

class RackResponse
  attr_reader :status, :body

  def initialize(status, body)
    @status = status
    @body = body
  end
end

def wrap_rack_response(raw_response)
  RackResponse.new raw_response[0], raw_response[2][0]
end
