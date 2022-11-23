# frozen_string_literal: true

require_relative '../app/app'
require_relative './generator_helper'
require_relative './spec_helper'

RSpec.describe UserController do
  let(:app) { Application.new }
  let(:user) { UserGenerator.generate }
  let(:environment) { Environment.new(app) }

  before(:example) do
    REDIS_CONNECTION.flushall
  end

  context 'user validation' do
    it 'creates new user' do
      req_body = user.to_json
      response = environment.simulate_request('POST', '/user/data', req_body)

      expect(response.status).to eq 201
      expect(response.body).to eq req_body

      expect { User.find(user.name) }.to eq(user)

      # сгенерить данные
      # послать запрос
      # проверить код ответа
      # (опц) проверить тело ответа
      # (опц) проверить по базе
    end
  end
end