# frozen_string_literal: true

require_relative '../app/app'
require_relative 'helper'
require_relative 'generator_helper'

RSpec.describe UserController do
  let(:app) { Application.new }
  let(:user) { UserGenerator.new }
  #let(:environment) { Environment.new(app) }

  before(:example) do
    REDIS_CONNECTION.flushall
  end

  # after(:all) { User.find(req_body[:name]).delete }

  context 'user validation' do
    it 'creates new user' do
      # unique data has to be generated each time
      req_body = user.user_data
      # написать helper что будет принимать 4 аргумента и генерить response
      # resp = environment.perform_request('POST', '/path', req_body)

      resp = app.call env
      # [code, headers, [content]]
      # response parses needed
      resp_status = resp[0]
      resp_body = resp[2][0]

      expect(resp_status).to eq 201
      expect(resp_body).to eq req_body

      # has to be smth like expect { User.find(...) }.to eq(..)
      expect { User.find(req_body[:name]) }.to req_body.to_s

      # сгенерить данные
      # послать запрос
      # проверить код ответа
      # (опц) проверить тело ответа
      # (опц) проверить по базе
    end
  end
end