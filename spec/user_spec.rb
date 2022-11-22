# frozen_string_literal: true

require_relative '../app/app'
require_relative 'helper'
require_relative 'generator_helper'

RSpec.describe UserController do
  let(:app) { Application.new }
  let(:user) { UserGenerator.new }
  let(:environment) { Environment.new(app) }

  before(:example) do
    REDIS_CONNECTION.flushall
  end

  # after(:all) { User.delete_user(user.name) } # todo

  context 'user validation' do
    it 'creates new user' do
      # unique data has to be generated each time
      req_body = user.user_data
      # написать helper что будет принимать 4 аргумента и генерить response
      resp = environment.simulate_request('POST', '/user/data', req_body)

      response = ApplicationResponse.new(resp)
      # [code, headers, [content]]
      # response parses needed

      expect(response.status).to eq 201
      expect(response.body).to eq req_body

      # has to be smth like expect { User.find(...) }.to eq(..)
      expect { User.find(user.name) }.to eq(req_body)

      # сгенерить данные
      # послать запрос
      # проверить код ответа
      # (опц) проверить тело ответа
      # (опц) проверить по базе
    end
  end
end