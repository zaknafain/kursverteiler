# frozen_string_literal: true

# Rails base controller
class ApplicationController < ActionController::Base
  # allow_browser versions: :modern
  protect_from_forgery with: :null_session
  before_action :set_locale
  skip_after_action :verify_same_origin_request
  skip_before_action :verify_authenticity_token

  private

  def set_locale
    possible_locales = [params[:locale], session[:locale], I18n.default_locale]
    I18n.locale = possible_locales.compact.detect { |l| I18n.available_locales.include?(l.to_sym) }
    session[:locale] = I18n.locale
  end
end
