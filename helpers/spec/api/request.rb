# frozen_string_literal: true

def request(method, endpoint, body)
  {
    'REQUEST_PATH' => endpoint,
    'PATH_INFO' => endpoint,
    'REQUEST_METHOD' => method,
    'rack.input' => StringIO.new(body)
  }
end
