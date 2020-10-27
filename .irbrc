# frozen_string_literal: true

require 'rubygems'

if ENV.include?('RAILS_ENV') && ENV['RAILS_ENV'] == 'development'
  ActiveRecord::Base.logger = Logger.new($stdout)
  ActiveRecord::Base.connection_pool.clear_reloadable_connections!
end
