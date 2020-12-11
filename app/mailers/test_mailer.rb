# frozen_string_literal: true

# Mailer for testing purposes
class TestMailer < ApplicationMailer

  def send_test_mail(email)
    @sender = admin

    mail(to: email, subject: 'E-Mail Test für automatische E-Mails')
  end

  private

  def admin
    Admin.new(first_name: 'David', last_name: 'Seeherr', email: 'david.seeherr@bs30.de')
  end

end
