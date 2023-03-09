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

  before(:each) { User.delete_all }

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
  end

  it 'fails to create user with invalid name' do
    invalid_name_user = TestUser.invalid_name
    response = Response.new(app.call(request('POST', '/user/new', invalid_name_user.to_json)))

    expect(response.code).to eq(422)
    expect(response.body.strip).to eq('Invalid name. Must contain only latin alphabet characters, numbers and have length from 1 to 30 chars. No spaces allowed.')
    expect(invalid_name_user.exists?).to eq(false)
  end

  it 'fails to create user with invalid age' do
    invalid_age_user = TestUser.invalid_age
    response = Response.new(app.call(request('POST', '/user/new', invalid_age_user.to_json)))

    expect(response.code).to eq(422)
    expect(response.body.strip).to eq('Invalid age. Must be integral number not less than 0.')
    expect(invalid_age_user.exists?).to eq(false)
  end

  it 'fails to create user with invalid gender' do
    invalid_gender_user = TestUser.invalid_gender
    response = Response.new(app.call(request('POST', '/user/new', invalid_gender_user.to_json)))

    expect(response.code).to eq(422)
    expect(response.body.strip).to eq('Invalid gender. Must be Male, Female or Nonbinary')
    expect(invalid_gender_user.exists?).to eq(false)
  end

  it 'gets user' do
    age = 1_000_000_000
    gender = :m
    expected_background_color = 'DeepSkyBlue'
    expected_years_as_string = 31
    expected_months_as_string = 8
    expected_days_as_string = 8
    user = TestUser.save age: age, gender: gender

    response = Response.new(app.call(request('GET', "/user/html/#{user.name}", '')))
    expect(response.code).to eq(200)
    expect(response.html?).to eq(true)

    response.parse_html_body
    expect(response.background_color).to eq(expected_background_color)
    expect(response.user_name).to eq(user.name)

    expect(response.years).to eq(expected_years_as_string)
    expect(response.months).to eq(expected_months_as_string)
    expect(response.days).to eq(expected_days_as_string)
  end

  it 'cannot get unexisting user' do
    User.delete(test_user.name)
    response = Response.new(app.call(request('GET', "/user/html/#{test_user.name}", '')))

    expect(response.code).to eq(404)
    expect(response.body).to eq('User is not found')
  end

  it 'updates user' do
    old_user = TestUser.save gender: :m
    updated_user_params = TestUser.create name: old_user.name, gender: %w[f nb].sample,
                                          age: rand(1_000_000_000)
    response = Response.new(app.call(request('PUT', '/user/update', updated_user_params.to_json)))

    expect(response.code).to eq(200)
    expect(response.body).to eq('User is updated!')
    expect(updated_user_params.exists?).to eq(true)

    old_user_updated = User.find(old_user.name)

    expect(old_user_updated.age).to eq(updated_user_params.age)
    expect(old_user_updated.gender).to eq(updated_user_params.gender)
  end

  it 'fails to update unexisting user' do
    User.delete(test_user.name)
    response = Response.new(app.call(request('PUT', '/user/update', test_user.to_json)))

    expect(response.code).to eq(404)
    expect(response.body).to eq('User is not found')
  end

  it 'fails to update user with invalid age' do
    old_user = TestUser.save
    updated_user_params = TestUser.invalid_age name: old_user.name
    response = Response.new(app.call(request('PUT', '/user/update', updated_user_params.to_json)))

    expect(response.code).to eq(422)
    expect(response.body.strip).to eq('Invalid age. Must be integral number not less than 0.')
    expect(User.find(old_user.name).age).to eq(old_user.age)
  end

  it 'fails to update user with invalid gender' do
    old_user = TestUser.save
    updated_user_params = TestUser.invalid_gender name: old_user.name
    response = Response.new(app.call(request('POST', '/user/new', updated_user_params.to_json)))

    expect(response.code).to eq(422)
    expect(response.body.strip).to eq('Invalid gender. Must be Male, Female or Nonbinary')
    expect(old_user.exists?).to eq(true)
    expect(User.find(old_user.name).gender).to eq(old_user.gender)
  end

  it 'deletes user' do
    user_to_be_deleted = TestUser.save
    response = Response.new(app.call(request('DELETE', "/user/#{user_to_be_deleted.name}", '')))

    expect(response.code).to eq(204)
    expect(response.body).to eq('User is deleted')
    expect(user_to_be_deleted.exists?).to eq(false)
  end

  it 'fails to delete unexisting user' do
    User.delete(test_user.name)
    response = Response.new(app.call(request('DELETE', "/user/#{test_user.name}", '')))

    expect(response.code).to eq(404)
    expect(response.body).to eq('User is not found')
    expect(test_user.exists?).to eq(false)
  end

  it 'gets all users' do
    rand(100..500).times do
      TestUser.save
    end
    response = Response.new(app.call(request('GET', '/get_users', '')))

    expect(response.code).to eq(200)
    expect(JSON.parse(response.body)).to match_array(User.list)
  end
end
