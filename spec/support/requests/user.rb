# frozen_string_literal: true

require 'rack'

PATHS = {
  new_user: %w[/api/new_user],
  user_by_name: %w[/user/ $name]
}.freeze

METHODS = {
  put: 'PUT'
}.freeze

def make_path(path_arr, path_props)
  path = ''
  path_arr.each do |block|
    if block.start_with? '$'
      prop = block.gsub '$', ''
      prop_value = path_props[prop.to_sym]
      raise "not found value for property '#{prop}'" unless prop_value

      path += prop_value
    else
      path += block
    end
  end
  path
end

def make_req(method, path, body)
  env = { 'REQUEST_METHOD' => method,
          'PATH_INFO' => path }
  env['rack.input'] = StringIO.new(JSON.generate(body)) if body
  env
end

def user_request(path_key, method, body = nil, **path_props)
  path_arr = PATHS[path_key]
  raise 'unknown path' unless path_arr

  method = METHODS[method]
  raise 'unknown method' unless method

  path = make_path(path_arr, path_props)
  make_req method, path, body
end
