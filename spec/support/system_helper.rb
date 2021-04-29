# frozen_string_literal: true

# Custom driver to change default window size
Capybara.register_driver :custom_selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-site-isolation-trials')
  options.add_argument('--window-size=1600,800')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :custom_selenium_chrome_headless

RSpec.configure do |config|
  # Ensure correct webdriver for systems specs
  config.before(:each, type: :system) do
    driven_by Capybara.javascript_driver
  end
end
