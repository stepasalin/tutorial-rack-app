# frozen_string_literal: true

require 'dotenv'

Dotenv.load

case ENV['PROFILE']
when 'dev'
  port = ENV['REDIS_DEV_PORT']
when 'test'
  port = ENV['REDIS_TEST_PORT']
else
  raise 'unknown application profile'
end
REDIS_CONNECTION = Redis.new({ port: port })
