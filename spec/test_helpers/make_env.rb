def make_env(method, path, body)
  { 'REQUEST_METHOD' => method.to_s.upcase, 'PATH_INFO' => path, 'rack.input' => StringIO.new(body) }
end