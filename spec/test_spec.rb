require 'stringio'
require_relative '../app'
require_relative '../helpers/redis'
require_relative './factories/user_factory'
require_relative './test_helpers/response_getter'

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
    it 'renders 404 page if route is not known' do
      env = {'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/test'}
      response = app.call(env)
      response_status = response[0]
      response_body = response[2][0]

      expect(response_status).to eq 404
      expect(response_body).to eq "Sorry, dunno what to do about GET /test"
    end

    it 'edits user with valid params' do
      user = UserFactory.create
      new_gender = 'm'
      new_age = 223123211

      body = { 'name'=> user['name'], 'gender'=> new_gender, 'age'=> new_age }.to_json
      env = { 'REQUEST_METHOD' => 'PUT', 'PATH_INFO' => "/user/#{user['name']}", 'rack.input' => StringIO.new(body) }
      env = make_env :put, "/user/#{user['name']}", body
      # TODO сделать метод make_env
      
      response = get_response env

      expect(response['status']).to eq 200
      expect(response['body']).to eq body.to_s

      user = User.find_by_name(user['name'])
      expect(user.gender.to_s).to eq new_gender
      expect(user.age).to eq new_age
    end
  end
end
