# frozen_string_literal: true

# Main Mailer from Rails
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
