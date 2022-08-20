require 'rack'
require 'pry'
require 'json'

run do |env|
  req = Rack::Request.new(env)
  if req.post? && req.path == '/epic-post'
    req_body = JSON.parse(req.body.read)
    [200, {}, ["epic post detected! The body is #{req_body}"]]
  elsif req.get? && req.path == '/epic-get'
    [200, {}, ['epic get detected!']]
  else
    [404,{}, ["Sorry, dunno what to do about #{req.request_method} #{req.path}"]]
  end
end