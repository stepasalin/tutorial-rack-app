# frozen_string_literal: true

require_relative '../../app'
require_relative '../../helpers/spec/api/request'
require_relative '../../helpers/spec/api/response'
require_relative '../../helpers/spec/api/test_user'
require_relative '../../helpers/html_page'

describe 'API' do
  let(:app) { Application.new }
  let(:test_user_data) { TestUser.create }
  let(:test_user) { TestUser.save }

  before(:each) { REDIS_CONNECTION.flushdb }

  it 'creates User' do
    response = Response.new(app.call(request('POST', '/user/new', test_user_data.to_json)))

    expect(response.code).to eq(201)
    expect(response.body).to eq('new user is created!')

    user_info = User.find(test_user_data.name)

    expect(user_info.name).to eq(test_user_data.name)
    expect(user_info.age).to eq(test_user_data.age)
    expect(user_info.gender).to eq(test_user_data.gender)
  end

  it 'fails to create user if name is taken' do
    created_user = TestUser.save
    response = Response.new(app.call(request('POST', '/user/new', created_user.to_json)))

    expect(response.code).to eq(409)
    expect(response.body).to eq('User is already created')

    user_info = User.find(created_user.name)

    expect(user_info.name).to eq(created_user.name)
    expect(user_info.age).to eq(created_user.age)
    expect(user_info.gender).to eq(created_user.gender)
  end

  it 'fails to create user with invalid name' do
    invalid_name_user = TestUser.invalid_name
    response = Response.new(app.call(request('POST', '/user/new', invalid_name_user.to_json)))

    expect(response.code).to eq(422)
    expect(response.body.strip).to eq('Invalid name. Must contain only latin alphabet characters, numbers and have length from 1 to 30 chars. No spaces allowed.')
    expect(REDIS_CONNECTION.exists(invalid_name_user.name)).to eq(0)
    expect(REDIS_CONNECTION.exists(test_user.name)).to eq(1)

    user_info = User.find(test_user.name)

    expect(user_info.name).to eq(test_user.name)
    expect(user_info.age).to eq(test_user.age)
    expect(user_info.gender).to eq(test_user.gender)
  end

  it 'fails to create user with invalid age' do
    invalid_age_user = TestUser.invalid_age
    response = Response.new(app.call(request('POST', '/user/new', invalid_age_user.to_json)))

    expect(response.code).to eq(422)
    expect(response.body.strip).to eq('Invalid age. Must be integral number not less than 0.')
    expect(REDIS_CONNECTION.exists(invalid_age_user.name)).to eq(0)
    expect(REDIS_CONNECTION.exists(test_user.name)).to eq(1)

    user_info = User.find(test_user.name)

    expect(user_info.name).to eq(test_user.name)
    expect(user_info.age).to eq(test_user.age)
    expect(user_info.gender).to eq(test_user.gender)
  end

  it 'fails to create user with invalid gender' do
    invalid_gender_user = TestUser.invalid_gender
    response = Response.new(app.call(request('POST', '/user/new', invalid_gender_user.to_json)))

    expect(response.code).to eq(422)
    expect(response.body.strip).to eq('Invalid gender. Must be Male, Female or Nonbinary')
    expect(REDIS_CONNECTION.exists(invalid_gender_user.name)).to eq(0)
    expect(REDIS_CONNECTION.exists(test_user.name)).to eq(1)

    user_info = User.find(test_user.name)

    expect(user_info.name).to eq(test_user.name)
    expect(user_info.age).to eq(test_user.age)
    expect(user_info.gender).to eq(test_user.gender)
  end

  it 'gets user' do
    # define age - method, gvozdyami pribivaet user age, dlya bolee gramotnoi convertacii v years\months\days
    user = TestUser.define_age
    response = Response.new(app.call(request('GET', "/user/html/#{user.name}", '')))
    expect(response.code).to eq(200)
    expect(response.html?).to eq(true)

    response.parse_html_body
    expect(response.background_color).to eq(page_color(user.gender))
    expect(response.user_name).to eq(user.name)

    expect(response.years).to eq(TestUser.years(user.age))
    expect(response.months).to eq(TestUser.months(user.age))
    expect(response.days).to eq(TestUser.days(user.age))
  end

  it 'cannot get unexisting user' do
    REDIS_CONNECTION.del(test_user.name)
    response = Response.new(app.call(request('GET', "/user/html/#{test_user.name}", '')))

    expect(response.code).to eq(404)
    expect(response.body).to eq('User is not found')
  end

  it 'updates user' do
    old_user = TestUser.save gender: :m
    updated_user_params = TestUser.create name: old_user.name, gender: %w[f nb].sample,
                                          age: rand(1_000_000_000)
    response = Response.new(app.call(request('POST', '/user/update', updated_user_params.to_json)))

    expect(response.code).to eq(200)
    expect(response.body).to eq('User is updated!')
    expect(REDIS_CONNECTION.exists(updated_user_params.name)).to eq(1)

    user_info = User.find(updated_user_params.name)

    expect(user_info.name).to eq(updated_user_params.name)
    expect(user_info.age).to eq(updated_user_params.age)
    expect(user_info.gender).to eq(updated_user_params.gender)
    expect(user_info.name).to eq(old_user.name)
  end

  it 'fails to update unexisting user' do
    user_to_be_deleted = TestUser.create
    REDIS_CONNECTION.del(user_to_be_deleted.name)
    response = Response.new(app.call(request('POST', '/user/update', user_to_be_deleted.to_json)))

    expect(response.code).to eq(404)
    expect(response.body).to eq('User is not found')
    expect(REDIS_CONNECTION.exists(user_to_be_deleted.name)).to eq(0)

    user_info = User.find(test_user.name)

    expect(user_info.name).to eq(test_user.name)
    expect(user_info.age).to eq(test_user.age)
    expect(user_info.gender).to eq(test_user.gender)
  end

  it 'fails to update user with invalid age' do
    old_user = TestUser.save
    updated_user_params = TestUser.invalid_age name: old_user.name
    response = Response.new(app.call(request('POST', '/user/update', updated_user_params.to_json)))

    expect(response.code).to eq(422)
    expect(response.body.strip).to eq('Invalid age. Must be integral number not less than 0.')
    expect(REDIS_CONNECTION.exists(old_user.name)).to eq(1)
    expect(REDIS_CONNECTION.exists(test_user.name)).to eq(1)

    user_info = User.find(test_user.name)

    expect(user_info.name).to eq(test_user.name)
    expect(user_info.age).to eq(test_user.age)
    expect(user_info.gender).to eq(test_user.gender)
  end

  it 'fails to update user with invalid gender' do
    old_user = TestUser.save
    updated_user_params = TestUser.invalid_gender name: old_user.name
    response = Response.new(app.call(request('POST', '/user/new', updated_user_params.to_json)))

    expect(response.code).to eq(422)
    expect(response.body.strip).to eq('Invalid gender. Must be Male, Female or Nonbinary')
    expect(REDIS_CONNECTION.exists(old_user.name)).to eq(1)
    expect(REDIS_CONNECTION.exists(test_user.name)).to eq(1)

    user_info = User.find(test_user.name)

    expect(user_info.name).to eq(test_user.name)
    expect(user_info.age).to eq(test_user.age)
    expect(user_info.gender).to eq(test_user.gender)
  end

  it 'deletes user' do
    user_to_be_deleted = TestUser.save
    response = Response.new(app.call(request('DELETE', "/user/#{user_to_be_deleted.name}", '')))

    expect(response.code).to eq(204)
    expect(response.body).to eq('User is deleted')
    expect(REDIS_CONNECTION.exists(user_to_be_deleted.name)).to eq(0)
    expect(REDIS_CONNECTION.exists(test_user.name)).to eq(1)
  end

  it 'fails to delete unexisting user' do
    REDIS_CONNECTION.del(test_user.name)
    response = Response.new(app.call(request('DELETE', "/user/#{test_user.name}", '')))

    expect(response.code).to eq(404)
    expect(response.body).to eq('User is not found')
    expect(REDIS_CONNECTION.exists(test_user.name)).to eq(0)
  end

  it 'gets all users' do
    users_num = rand(100..500)
    users_num.times do
      TestUser.save
    end
    response = Response.new(app.call(request('GET', '/get_users', '')))

    expect(response.code).to eq(200)
    expect(response.body.gsub(',', ', ')).to eq(REDIS_CONNECTION.keys('*').to_s)
    expect(response.body.split(',').count).to eq(users_num)
  end
end
