# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.0', '>= 6.0.3.3'
# Database for Active Record
gem 'pg', '~> 1.2.3'
# Use Puma as the app server
gem 'puma', '~> 5.3.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.10'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.16'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
# Handle Authentication for users
gem 'devise', '~> 4.8.0'
gem 'devise-i18n', '~> 1.9.2'
# Dashboard for admins
gem 'rails_admin', git: 'https://github.com/zaknafain/rails_admin', branch: 'multiselect_options'
gem 'rails_admin_import', git: 'https://github.com/zaknafain/rails_admin_import', branch: 'enumeration_translation'

# Generate fake data for development, testing and staging
gem 'faker', '~> 2.18.0'

gem 'rubyzip', '~> 2.3.0'
gem 'write_xlsx', '~> 1.07.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # FactoryBot and RSpec for testing
  gem 'factory_bot', '~> 6.2.0'
  gem 'rspec-rails', '~> 5.0.1'
end

group :development do
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # Rubocop for linting
  gem 'rubocop', '~> 1.16.1', require: false
  gem 'rubocop-rails', '~> 2.10.1', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
