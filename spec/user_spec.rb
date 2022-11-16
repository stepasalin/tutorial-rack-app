# frozen_string_literal: true

require_relative '../app/app'
require 'pry'

RSpec.describe UserController do
  let(:app) { Application.new }

  before(:example) do
    REDIS_CONNECTION.flushall
  end

  context 'user validation' do
    it 'creates new user' do
      req_body = '{"name":"asd","gender":"m","age":123}'

      env = { 
        "REQUEST_METHOD" => "POST",
        "PATH_INFO" => "/user/data",
        'rack.input' => StringIO.new(req_body)
      }

      resp = app.call env
      resp_status = resp[0]
      resp_body = resp[2][0]

      expect(resp_status).to eq 201
      expect(resp_body).to eq req_body

      expect { User.find 'asd' }.not_to raise_error
    end
  end
end