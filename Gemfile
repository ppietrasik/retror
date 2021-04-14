# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Rails
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.3'
gem 'redis', '~> 4.0'
gem 'webpacker', '~> 5.0'

gem 'blueprinter'

group :development, :test do
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 5.0.0'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'solargraph'
end

group :test do
  gem 'capybara'
  gem 'cuprite'
  gem 'shoulda-matchers', '~> 4.5', '>= 4.5.1'
end
