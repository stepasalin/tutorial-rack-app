# frozen_string_literal: true

class Response
  attr_reader :code, :headers, :body

  def initialize(response)
    @code = response[0]
    @headers = response[1]
    @body = response[2]
  end
end
