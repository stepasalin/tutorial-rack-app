require_relative '../app'
require_relative '../helpers/redis_helper'

describe Application do
  let(:app) { Application.new }
  
  context 'errors: ' do
    before(:example) do
      REDIS_CONNECTION.flushall
      @start_time = Time.now
    end
    after(:example) do
      @end_time = Time.now
      puts "start time: #{@start_time}"
      puts "end time: #{@end_time}"
    end
    it 'renders 404 page if route is not known' do
      env = {'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/123123'}
      response = app.call(env)
      response_status = response[0]
      response_body = response[2][0]
      
      expect(response_status).to eq 404
      expect(response_body).to eq "Sorry, dunno what to do about GET /123123 1"
    end
  end
end

# СОСТАВИТЬ ТЕСТ-ПЛАН ПО ТЕСТИРОВАНИЮ API: какие эндпоинты какими запросами будут тестироваться
# ПРОДУМАТЬ ИНФРАСТРУКТУРУ (что с базой?)
# РЕАЛИЗОВАТЬ