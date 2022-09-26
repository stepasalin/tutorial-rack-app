def gen_put_request(name, gender, age)
  body = { 'name'=> name, 'gender'=> gender, 'age'=> age }.to_json
  env = { 'REQUEST_METHOD' => 'PUT', 'PATH_INFO' => "/user/#{name}", 'rack.input' => StringIO.new(body) }
end