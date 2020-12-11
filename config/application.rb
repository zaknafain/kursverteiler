# frozen_string_literal: true

require_relative 'boot'

# require 'rails/all'
# action_mailbox/engine
require 'rails'

%w[
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  action_cable/engine
  active_storage/engine
  active_support/all
  action_text/engine
  rails/test_unit/railtie
  sprockets/railtie
].each do |railtie|
  require railtie
rescue LoadError
  puts 'Could not load railtie'
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
ENV['RAILS_ADMIN_THEME'] = 'bs30'

module Kursverteiler
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    # Locale configuration
    config.i18n.available_locales = %i[de en]
    config.i18n.default_locale = :de

    # X Header options
    config.action_dispatch.default_headers = {
      'X-XSS-Protection' => '1; mode=block',
      'X-Content-Type-Options' => 'nosniff',
      'P3P' => 'CP="NOI ADM DEV PSAi COM NAV OUR OTRo STP IND DEM"'
    }

    # Session configuration
    config.session_store :cookie_store,
      key: '_kursverteiler_session',
      expire_after: 1.year,
      same_site: :lax,
      secure: Rails.env.production?
  end
end
