
env = {
        "REQUEST_METHOD" => "POST",
        "PATH_INFO" => "/user/data",
        'rack.input' => StringIO.new(req_body)
      }