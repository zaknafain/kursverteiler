# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.10'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0'
# Logger pinned to match the default gem shipped with Ruby 3.2.x (1.5.3) to avoid
# conflicts when newer versions are resolved by bundler
gem 'logger', '~> 1.5.0'
# Database for Active Record
gem 'pg', '~> 1.6.0'
# Use Puma as the app server
gem 'puma', '~> 7.2.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Use Sprockets for assets
gem 'sprockets-rails'
# Use importmap for JavaScript
gem 'importmap-rails'
# Hotwire's SPA-like page accelerator
gem 'turbo-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.10'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.22'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
# Handle Authentication for users
gem 'devise', '~> 4.9.4'
gem 'devise-i18n', '~> 1.15.0'
# Dashboard for admins
gem 'rails_admin', git: 'https://github.com/zaknafain/rails_admin', branch: 'multiselect_options'
gem 'rails_admin_import', git: 'https://github.com/zaknafain/rails_admin_import', branch: 'enumeration_translation'

# Generate fake data for development, testing and staging
gem 'faker', '~> 2.18.0'

gem 'rubyzip', '~> 3.2.2'
gem 'write_xlsx', '~> 1.13.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # FactoryBot and RSpec for testing
  gem 'factory_bot', '~> 6.5.6'
  gem 'rspec-rails', '~> 6.1.5'
end

group :development do
  gem 'listen', '~> 3.10'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Rubocop for linting
  gem 'rubocop', '~> 1.85.1', require: false
  gem 'rubocop-rails', '~> 2.34.3', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
