# frozen_string_literal: true

require 'capybara/rspec'
require 'capybara/dsl'
require 'webdrivers/chromedriver'
require_relative 'features/pages/main_page.rb'

RSpec.configure do |config|
  config.include Capybara::DSL, :features

  config.define_derived_metadata(file_path: %r{/spec/features/}) do |metadata|
    metadata[:features] = true
  end

  config.before :all, :features do
    Capybara.run_server = false

    options = Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    end
    
    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: [options])
    end
    
    Capybara.default_driver = :chrome
    Capybara.default_max_wait_time = 30
    
    Capybara.app = Rack::Builder.parse_file(File.expand_path('../config.ru', __dir__))
  end

  config.before(:example) do
    REDIS_CONNECTION.flushall
  end
end

class RackResponse
  attr_reader :status, :body

  def initialize(status, body)
    @status = status
    @body = body
  end
end

def execute_rack_request(app, request)
  response = app.call request
  RackResponse.new response[0], response[2][0]
end
