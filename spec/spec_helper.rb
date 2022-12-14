require 'capybara/rspec'
require 'capybara/dsl'
require 'webdrivers/chromedriver'
require_relative './generator_helper.rb'

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


class ApplicationResponse
  def initialize(response)
    @response = response
  end


  def status
    @response[0]
  end


  def body
    @response[2][0]
  end
end



class Environment
  def initialize(app)
    @app = app
  end


  def simulate_request(method, path, body)
    response = @app.call({
      "REQUEST_METHOD" => method,
      "PATH_INFO" => path,
      "rack.input" => StringIO.new(body)
      })

    ApplicationResponse.new(response)
  end
end