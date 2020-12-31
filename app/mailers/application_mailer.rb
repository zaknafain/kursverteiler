# frozen_string_literal: true

# Main Mailer from Rails
class ApplicationMailer < ActionMailer::Base
  default from: 'kursverteiler@bs30.de'
  layout 'mailer'

end
