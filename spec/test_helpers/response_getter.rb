def get_response(env)
  response = app.call(env)
  {'status' => response[0], 'body' => response[2][0]}
end