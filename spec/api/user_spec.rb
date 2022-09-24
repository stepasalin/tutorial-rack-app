# frozen_string_literal: true

require_relative '../../app/app'
require_relative '../support/factories/user'
require_relative '../support/requests'
require_relative '../spec_helper'
require 'pry'

RSpec.describe UserController do
  let(:app) { Application.new }

  before(:example) do
    REDIS_CONNECTION.flushall
  end

  context 'user validation' do
    it 'validates multiple invalid params' do

    end

    it 'validates too long name' do

    end
  end

  it 'creates user successfully' do
    user = UserFactory.create_user
    req = generate_request_env 'POST', '/api/new_user', user

    resp = execute_rack_request app req
    expect(resp.status).to eq 201
    expect(resp.body).to eq 'OK'

    saved_user = User.find_by_name user.name
    expect(user).to eq saved_user
  end

  it 'sends get by user creation route' do

  end

  it 'creates user with already took name' do

  end

  it 'sends post by not accepted user route' do

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
      resp = execute_rack_request app req
      expect(resp.status).to eq 200
      expect(resp.body).to eq user_update_params

      updated_user = User.find_by_name name
      expect(updated_user.age).to eq updated_age
      expect(updated_user.gender).to eq updated_gender
    end

    it 'updates created user with multiple invalid params' do

    end

    it 'updates created user with too long name' do

    end

    it 'updates user with different names in path and body' do

    end

    it 'updates not exists user' do

    end
  end

  it 'deletes not exists user' do

  end

  it 'deletes user successfully' do

  end
end
