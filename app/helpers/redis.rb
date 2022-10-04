# frozen_string_literal: true

REDIS_PORT = ENV['REDIS_PORT'] || 6379
REDIS_CONNECTION = Redis.new(port: REDIS_PORT)
