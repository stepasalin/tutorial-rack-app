# frozen_string_literal: true

require_relative '../app/app'
require_relative './generator_helper'
require_relative './spec_helper'

RSpec.describe UserController do
  let(:app) { Application.new }
  let(:generated_user) { (UserGenerator.generate) }
  let(:user) { UserGenerator.create }
  let(:environment) { Environment.new(app) }

  before(:example) do
    REDIS_CONNECTION.flushall
  end

  context 'user validation' do
    it 'creates a new user' do
      req_body = generated_user.to_json
      response = environment.simulate_request('POST', '/user/data', req_body)

      expect(response.status).to eq 201
      expect(response.body).to eq req_body

      expect(User.find(generated_user.name)).to eq(generated_user)
    end

    #binding.pry

    it 'gets an existing user' do
      response = environment.simulate_request("GET", "/user/data/#{user.name}", "")

      expected_res_body = user.to_json
      expect(response.status).to eq 200
      expect(response.body).to eq expected_res_body
    end


    it 'deletes an existing user' do
      response = environment.simulate_request("DELETE", "/user/data/#{user.name}", "")

      expected_res_body = user.to_json
      expect(response.status).to eq 202
      expect(response.body).to eq expected_res_body

      expect { User.find(user.name) }.to raise_error KeyExistingdError
    end


    it 'updates an existing user' do
      user_in_db = UserGenerator.create gender: :m, age: 123
      new_user_data = UserGenerator.generate name: user_in_db.name, gender: :f, age: 654
      req_body = new_user_data.to_json

      response = environment.simulate_request("PUT", "/user/data/#{user_in_db.name}", req_body)

      # todo обсудить как мы используем захардкодженные данные

      expect(response.status).to eq 200
      expect(response.body).to eq req_body

      expect(User.find(user_in_db.name)).to eq new_user_data
    end


    it 'checks empty name for a new user' do
      user = UserGenerator.generate(name: '')
      req_body = user.to_json
      response = environment.simulate_request('POST', '/user/data', req_body)

      expect(response.status).to eq 422
      expect(response.body).to eq "Error of name symbols '#{user.name}'. Accepted only leters and digits. "

      expect { User.find(user.name).to_json }.to raise_error KeyExistingdError
    end


    # it 'checks overlong name for a new user' do          # does not work, doesn't have such limitation in code
    #   user = UserGenerator.overlong_user_name
    #   req_body = user.to_json
    #   response = environment.simulate_request('POST', '/user/data', req_body)

    #   expect(response.status).to eq 422
    #   expect(response.body).to eq "Error of name symbols '#{user.name}'. Accepted only leters and digits. "

    #   expect { User.find(user.name).to_json }.to raise_error KeyExistingdError
    # end


    it 'checks a forbidden symbol in a user name' do
      user = UserGenerator.forbidden_name_symbol
      req_body = user.to_json
      response = environment.simulate_request('POST', '/user/data', req_body)

      expect(response.status).to eq 422
      expect(response.body).to eq "Error of name symbols '#{user.name}'. Accepted only leters and digits. "

      expect { User.find(user.name).to_json }.to raise_error KeyExistingdError
    end


    it 'checks an empty user gender' do
      user = UserGenerator.generate(gender: '')
      req_body = user.to_json
      response = environment.simulate_request('POST', '/user/data', req_body)

      expect(response.status).to eq 422
      expect(response.body).to eq "Error of gender '#{user.gender}'. Correct genders are '#{:m}', '#{:f}' or '#{:nb}'. "

      expect { User.find(user.name).to_json }.to raise_error KeyExistingdError
    end


    it 'checks a wrong user gender' do
      user = UserGenerator.wrong_user_gender
      req_body = user.to_json
      response = environment.simulate_request('POST', '/user/data', req_body)

      expect(response.status).to eq 422
      expect(response.body).to eq "Error of gender '#{user.gender}'. Correct genders are '#{:m}', '#{:f}' or '#{:nb}'. "

      expect { User.find(user.name).to_json }.to raise_error KeyExistingdError
    end


    it 'checks an empty user age' do
      user = UserGenerator.generate(age: '')
      req_body = user.to_json
      response = environment.simulate_request('POST', '/user/data', req_body)

      expect(response.status).to eq 422
      expect(response.body).to eq "Error of age '#{user.age}'. Age must be positive digits only."

      expect { User.find(user.name).to_json }.to raise_error KeyExistingdError
    end


    it 'checks a negative user age' do
      user = UserGenerator.generate(age: rand(-1..0))
      req_body = user.to_json
      response = environment.simulate_request('POST', '/user/data', req_body)

      expect(response.status).to eq 422
      expect(response.body).to eq "Error of age '#{user.age}'. Age must be positive digits only."

      expect { User.find(user.name).to_json }.to raise_error KeyExistingdError
    end


    it 'checks not digits in a user age' do
      user = UserGenerator.generate(age: " ")
      req_body = user.to_json
      response = environment.simulate_request('POST', '/user/data', req_body)

      expect(response.status).to eq 422
      expect(response.body).to eq "Error of age '#{user.age}'. Age must be positive digits only."

      expect { User.find(user.name).to_json }.to raise_error KeyExistingdError
    end
      # сгенерить данные
      # послать запрос
      # проверить код ответа
      # (опц) проверить тело ответа
      # (опц) проверить по базе

  end
end