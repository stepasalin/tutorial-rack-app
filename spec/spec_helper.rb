require 'capybara/rspec'
require 'capybara/dsl'
require 'webdrivers/chromedriver'
require_relative '../app'

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
end
