# frozen_string_literal: true

def internal_server_error
  [500, {}, ['internal server error']]
end

def route_not_found(req)
  [404, {}, ["Sorry, dunno what to do about #{req.request_method} #{req.path}"]]
end
