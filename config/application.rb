require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
ENV['RAILS_ADMIN_THEME'] = 'bs30'

module Kursverteiler
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    # Locale configuration
    config.i18n.available_locales = %i[de en]
    config.i18n.default_locale = :de

    # X Header options
    config.action_dispatch.default_headers = {
      # 'X-Frame-Options' => 'ALLOWALL',
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
