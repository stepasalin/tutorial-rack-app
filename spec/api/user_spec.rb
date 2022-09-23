# frozen_string_literal: true

require_relative '../../app/app'
require_relative '../support/factories/user'
require_relative '../support/requests/user'
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

  end

  it 'sends get by user creation route' do

  end

  it 'creates user with already took name' do

  end

  it 'sends post by not accepted user route' do

  end

  context 'user updating' do
    it 'updates created user' do
      old_user = create_user :valid, with_saving: true
      new_user = User.new old_user.name, :m, 123_123_123
      req = user_request :user_by_name, :put, new_user, name: old_user.name

      resp = wrap_rack_response app.call req
      expect(resp.status).to eq 200
      expect(new_user.to_json).to eq resp.body

      current_user = User.find_by_name old_user.name
      expect(current_user).to eq new_user
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
