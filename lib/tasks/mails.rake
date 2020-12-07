# frozen_string_literal: true

namespace :mails do
  desc 'Sends test emails to all given email addresses separated by semicolon'
  task :test_mails, [:email_string] => [:environment] do |_t, args|
    emails = args[:email_string].split(';')

    emails.each do |email|
      puts "Send test email to #{email.strip}"

      TestMailer.send_test_mail(email.strip).deliver
    end
  end
end
