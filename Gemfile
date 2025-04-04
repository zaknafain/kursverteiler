# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.6'

gem 'bootsnap', require: false
gem 'csv'
gem 'importmap-rails'
gem 'jbuilder'
gem 'pg'
gem 'propshaft'
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.0.1'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'thruster', require: false
gem 'turbo-rails'

gem 'bcrypt'
gem 'devise'
gem 'devise-i18n'

# Generate fake data for development, testing and staging
gem 'faker'

gem 'rubyzip'
gem 'write_xlsx'

group :development, :test do
  gem 'dotenv'
end

group :development do
  gem 'debug', platforms: %i[mri windows]
  gem 'spring'
  gem 'web-console'
end

group :test do
  gem 'brakeman', require: false
  gem 'capybara'
  gem 'factory_bot'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-capybara'
  gem 'rubocop-factory_bot'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
  gem 'rubocop-rspec_rails'
  gem 'selenium-webdriver'
end
