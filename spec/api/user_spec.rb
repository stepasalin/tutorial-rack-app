# frozen_string_literal: true

require_relative '../../app/app'
require_relative '../support/factories/user'
require_relative '../support/requests'
require_relative '../support/randomizers'
require_relative '../spec_helper'
require 'pry'

RSpec.describe UserController do
  let(:app) { Application.new }

  before(:example) do
    REDIS_CONNECTION.flushall
  end

  context 'user validation' do
    it 'validates multiple invalid params' do
      user = { name: '', age: -1, gender: :unknown }
      req = generate_request_env 'POST', '/api/new_user', user

      resp = execute_rack_request app, req
      expect(resp.status).to eq 422
      resp_body = JSON.parse(resp.body)
      expect(resp_body).to match_array [
        "name length must be between 1 and 30, actual = #{user[:name].length}",
        "unknown gender, accepted = #{User::GENDERS.map(&:to_s)}, actual = #{user[:gender]}",
        "age must be positive, actual = #{user[:age]}"
      ]

      expect { User.find_by_name user[:name] }.to raise_error UserNotFoundError
    end

    it 'validates too long name' do
      user = { name: ('a' * 31), age: 1, gender: :nb }
      req = generate_request_env 'POST', '/api/new_user', user

      resp = execute_rack_request app, req
      expect(resp.status).to eq 422
      resp_body = JSON.parse(resp.body)
      expect(resp_body).to match_array [
        "name length must be between 1 and 30, actual = #{user[:name].length}"
      ]

      expect { User.find_by_name user[:name] }.to raise_error UserNotFoundError
    end
  end

  it 'creates user successfully' do
    user = UserFactory.create_user
    req = generate_request_env 'POST', '/api/new_user', user

    resp = execute_rack_request app, req
    expect(resp.status).to eq 201
    expect(resp.body).to eq 'OK'

    saved_user = User.find_by_name user.name
    expect(user).to eq saved_user
  end

  xit 'sends get by user creation route' do
    method = 'GET'
    path = '/api/new_user'
    req = generate_request_env method, path

    resp = execute_rack_request app, req
    expect(resp.status).to eq 404
    expect(resp.body).to eq "Sorry, dunno what to do about #{method} #{path}"
  end

  it 'creates user with already took name' do
    user = UserFactory.create_user save: true
    req = generate_request_env 'POST', '/api/new_user', user

    resp = execute_rack_request app, req
    expect(resp.status).to eq 409
    expect(resp.body).to eq 'user name already taken'
  end

  xit 'sends post by not accepted user route' do

  end

  context 'user updating' do
    it 'updates created user' do
      name = 'user123'
      original_age = 20_000_000
      original_gender = :m
      user = User.new(name, original_gender, original_age)
      user.save

      updated_age = rand 10_000
      updated_gender = :nb
      user_update_params = { name: name, gender: updated_gender, age: updated_age }
      req = generate_request_env 'PUT', "/user/#{name}", user_update_params

      resp = execute_rack_request app, req
      expect(resp.status).to eq 200
      expect(resp.body).to eq JSON.generate(user_update_params)

      updated_user = User.find_by_name name
      expect(updated_user.age).to eq updated_age
      expect(updated_user.gender).to eq updated_gender
    end

    it 'updates created user with multiple invalid params' do
      user = UserFactory.create_user save: true

      user_update_params = { name: user.name, gender: :unknown, age: -1 }
      req = generate_request_env 'PUT', "/user/#{user.name}", user_update_params

      resp = execute_rack_request app, req
      expect(resp.status).to eq 422
      resp_body = JSON.parse(resp.body)
      expect(resp_body).to match_array [
        "unknown gender, accepted = #{User::GENDERS.map(&:to_s)}, actual = #{user_update_params[:gender]}",
        "age must be positive, actual = #{user_update_params[:age]}"
      ]
    end

    it 'updates user with different names in path and body' do
      user = UserFactory.create_user save: true
      req = generate_request_env 'PUT', '/user/just-random-string', user

      resp = execute_rack_request app, req
      expect(resp.status).to eq 400
      expect(resp.body).to eq 'user name in path not equal user name in body'
    end

    it 'updates not exists user' do
      user = UserFactory.create_user
      req = generate_request_env 'PUT', "/user/#{user.name}", user

      resp = execute_rack_request app, req
      expect(resp.status).to eq 404
      expect(resp.body).to eq 'User not found'
    end
  end

  it 'deletes not exists user' do
    user = UserFactory.create_user
    req = generate_request_env 'DELETE', "/user/#{user.name}", user

    resp = execute_rack_request app, req
    expect(resp.status).to eq 404
    expect(resp.body).to eq 'User not found'
  end

  it 'deletes user successfully' do
    user = UserFactory.create_user save: true
    req = generate_request_env 'DELETE', "/user/#{user.name}", user

    resp = execute_rack_request app, req
    expect(resp.status).to eq 200
    expect(resp.body).to eq user.to_json
  end
end
