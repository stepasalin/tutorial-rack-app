# frozen_string_literal: true

require_relative '../../app/app'

RSpec.describe UserController do
  let(:app) { Application.new }

  context 'create new invalid user' do
    it 'create user with empty name, invalid gender, negative age' do

    end

    it 'create user with too long name' do

    end
  end

  it 'create user successfully' do

  end

  it 'method get by user creation route' do

  end

  it 'create user with already took name' do

  end

  it 'method post by not accepted user route' do

  end

  context 'user updating' do
    it 'update created user' do

    end

    it 'update created user with full invalid data' do

    end

    it 'updated created user with too long name' do

    end

    it 'update user with different names in path and boyd' do

    end

    it 'update not existed user' do

    end
  end

  it 'delete not existed user' do

  end

  it 'delete user' do

  end
end
