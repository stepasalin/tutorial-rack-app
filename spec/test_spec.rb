require 'stringio'
require_relative '../app'
require_relative '../helpers/redis'
require_relative './factories/user_factory'
require_relative './test_helpers/response_getter'
require_relative './test_helpers/make_env'

describe Application do
  let(:app) { Application.new }

  context 'errors: ' do
    before(:all) do
      REDIS_CONNECTION.flushall
      @start_time = Time.now
    end
    after(:all) do
      @end_time = Time.now
      puts "start time: #{@start_time}"
      puts "end time: #{@end_time}"
    end

    it 'creates new user with valid params' do
      name = gen_random_string
      gender = gen_random_gender
      age = gen_random_age
      body = { 'name' => name, 'gender' => gender, 'age' => age }.to_json
      env = make_env :post, "/api/new_user", body

      response = get_response env

      expect(response['status']).to eq 201
      expect(response['body']).to eq body

      user = User.find_by_name(name)
      expect(user.gender.to_s).to eq gender
      expect(user.age).to eq age
    end

    it 'validates empty name and invalid age' do
      name = ""
      gender = gen_random_gender
      age = -gen_random_age
      body = { 'name' => name, 'gender' => gender, 'age' => age }.to_json
      env = make_env :post, "/api/new_user", body

      response = get_response env

      expect(response['status']).to eq 422
      expect(response['body']).to eq "[\"name length must be between 1 and 30, actual = 0\", \"age must be positive, actual = #{age}\"]"

      expect { User.find_by_name(name) }.to raise_error(UserNotFoundError)
    end

    it 'validates name length more than 30 and invalid gender' do
      name = gen_random_string(of_length: 31, to_length: 50)
      gender = gen_random_string(of_length: 3, to_length: 5)
      age = gen_random_age
      body = { 'name' => name, 'gender' => gender, 'age' => age }.to_json
      env = make_env :post, "/api/new_user", body

      response = get_response env

      expect(response['status']).to eq 422
      expect(response['body']).to eq "[\"name length must be between 1 and 30, actual = #{name.length}\", \"unknown gender, accepted = [\\\"fm\\\", \\\"m\\\", \\\"nb\\\"], actual = #{gender}\"]"

      expect { User.find_by_name(name) }.to raise_error(UserNotFoundError)
    end

    it 'can not create an existing user' do
      user = UserFactory.create gender: 'nb', age: 432132139
      new_gender = 'm'
      new_age = 323123211
      body = {'name' => user.name, 'gender' => new_gender, 'age' => new_age }.to_json
      
      env = make_env :post, '/api/new_user', body
      response = get_response env

      expect(response['status']).to eq 409
      expect(response['body']).to eq "user name already taken"

      user = User.find_by_name(user.name)
      expect(user.gender.to_s).not_to eq new_gender
      expect(user.age).not_to eq new_age
    end

    it 'edits user with valid params' do
      user = UserFactory.create gender: 'm', age: 123123123
      new_gender = 'fm'
      new_age = 223123211

      body = { 'name' => user.name, 'gender' => new_gender, 'age' => new_age }.to_json
      env = make_env :put, "/user/#{user.name}", body
      
      response = get_response env

      expect(response['status']).to eq 200
      expect(response['body']).to eq body.to_s

      user = User.find_by_name(user.name)
      expect(user.gender.to_s).to eq new_gender
      expect(user.age).to eq new_age
    end

    it 'can not update user with invalid parameters' do
      valid_gender = gen_random_gender
      valid_age = gen_random_age
      user = UserFactory.create gender: valid_gender, age: valid_age
      invalid_gender = gen_random_string(of_length: 3, to_length: 5)
      invalid_age = -gen_random_age

      body = { 'name' => user.name, 'gender' => invalid_gender, 'age' => invalid_age }.to_json
      env = make_env :put, "/user/#{user.name}", body
      
      response = get_response env

      expect(response['status']).to eq 422
      expect(response['body']).to eq "[\"unknown gender, accepted = [\\\"fm\\\", \\\"m\\\", \\\"nb\\\"], actual = #{invalid_gender}\", \"age must be positive, actual = #{invalid_age}\"]"

      user = User.find_by_name(user.name)
      expect(user.gender.to_s).to eq valid_gender
      expect(user.age).to eq valid_age
    end

    it 'can not edit a non-existent user' do
      name = gen_random_string
      gender = gen_random_gender
      age = gen_random_age
      body = { 'name' => name, 'gender' => gender, 'age' => age }.to_json
      env = make_env :put, "/user/#{name}", body

      response = get_response env

      expect(response['status']).to eq 404
      expect(response['body']).to eq 'User not found'
      expect { User.find_by_name(name) }.to raise_error(UserNotFoundError)
    end

    it 'deletes an existing user' do
      user = UserFactory.create
      env = make_env :delete, "/user/#{user.name}"
      response = get_response env

      expect(response['status']).to eq 200
      expect(response['body']).to eq user.to_json
      expect { User.find_by_name(user.name) }.to raise_error(UserNotFoundError)
    end

    it 'can not delete a non-existent user' do
      user = UserFactory.create
      env = make_env :delete, "/user/#{user.name}1"
      response = get_response env

      expect(response['status']).to eq 404
      expect(response['body']).to eq 'User not found'
      expect(User.find_by_name(user.name).to_json).to eq user.to_json
    end

    it 'gets a page of an existing user' do
      user = UserFactory.create
      env = make_env :get, "/user/#{user.name}"
      response = get_response env

      expect(response['status']).to eq 200
    end

    it 'can not get a page of a non-existing user' do
      user = UserFactory.create
      env = make_env :get, "/user/#{user.name}1"
      response = get_response env

      expect(response['status']).to eq 404
      expect(response['body']).to eq 'User not found'
    end
  end
end
