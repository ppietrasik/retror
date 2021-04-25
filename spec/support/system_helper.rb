# frozen_string_literal: true

require 'capybara/cuprite'

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, window_size: [1600, 800])
end
Capybara.javascript_driver = :cuprite

RSpec.configure do |config|
  # Ensure correct webdriver for systems specs
  config.before(:each, type: :system) do
    driven_by Capybara.javascript_driver
  end
end
