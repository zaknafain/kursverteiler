# frozen_string_literal: true

# Mailer for student related mail
class StudentsMailer < ApplicationMailer

  def inform_about_distribution
    @student = params[:student]
    @poll    = params[:poll]
    @course  = params[:course]

    mail(to: @student.email, subject: "Kurswahl #{@poll.title} abgeschlossen")
  end

end
