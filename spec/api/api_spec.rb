# frozen_string_literal: true

require 'securerandom'
require_relative '../../app'
require_relative '../../helpers/spec/api/request'
require_relative '../../helpers/spec/api/response'

describe 'API' do
  let(:app) { Application.new }
  let(:name) { SecureRandom.alphanumeric(10).downcase }
  let(:gender) { %w[m f nb].sample }
  let(:age) { rand(1..1_000_000_000_000) }

  before(:each) { REDIS_CONNECTION.flushdb }

  it 'creates User' do
    body = { 'name' => name, 'gender' => gender, 'age' => age }.to_json
    response = Response.new(app.call(request('POST', '/user/new', body)))

    expect(response.code).to eq(201)
    expect(response.body).to eq(['new user is created!'])
    expect(REDIS_CONNECTION.exists(name)).to eq(1)

    user_info = JSON.parse(REDIS_CONNECTION.get(name))

    expect(user_info['name']).to eq(name)
    expect(user_info['age']).to eq(age)
    expect(user_info['gender']).to eq(gender)
  end
end
