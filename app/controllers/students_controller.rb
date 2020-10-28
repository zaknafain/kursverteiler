# frozen_string_literal: true

# Controller, that handles all pages made directly for students.
class StudentsController < ApplicationController
  before_action :authenticate_student!

  def home
    @courses = Course.current.order(:title)
    @selections = current_student.current_selections.order(:priority)
  end
end
