# frozen_string_literal: true

# Controller, that handles all pages made directly for students.
class StudentsController < ApplicationController
  before_action :authenticate_student!

  def home
    poll = Poll.running_at(DateTime.now).first
    @courses = poll.courses.order(:title)
    @selections = current_student.selections.where(poll_id: poll.id).order(:priority)
  end
end
