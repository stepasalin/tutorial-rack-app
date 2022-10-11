# frozen_string_literal: true

def generate_request_env(method, path, body = nil)
  env = { 'REQUEST_METHOD' => method,
          'PATH_INFO' => path }
  env['rack.input'] = StringIO.new(JSON.generate(body)) if body
  env
end
