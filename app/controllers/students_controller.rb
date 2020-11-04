# frozen_string_literal: true

# Controller, that handles all pages made directly for students.
class StudentsController < ApplicationController
  before_action :authenticate_student!

  def home
    @grade         = current_student.grade
    @poll          = @grade.running_poll
    @courses       = @poll.courses.order(:title)
    @selections    = current_student.current_selections
    @top_selection = @selections.find_or_initialize_by(priority: 0)
    @mid_selection = @selections.find_or_initialize_by(priority: 1)
    @low_selection = @selections.find_or_initialize_by(priority: 2)
  end

  def update_selections; end

end
