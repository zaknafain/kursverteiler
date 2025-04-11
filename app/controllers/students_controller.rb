# frozen_string_literal: true

# Controller, that handles all pages made directly for students.
class StudentsController < ApplicationController
  before_action :authenticate_student!
  before_action :fetch_data

  def update
    if selection.update(update_params[:current_selection])
      redirect_to student_path, notice: t('.saved'), status: :see_other
    else
      redirect_to student_path, alert: selection.errors.full_messages, status: :see_other
    end
  end

  private

  def fetch_data
    @grade   = current_student.grade
    @poll    = @grade&.running_poll
    @courses = @poll&.courses&.order(:title)
    selection
    @past_courses = current_student.courses.where.not(poll: [@poll])
  end

  def selection
    @selection ||= current_student.current_selection || initialize_selection
  end

  def initialize_selection
    current_student.selections.new(poll: @poll)
  end

  def update_params
    params.require(:student).permit(current_selection: %i[top_course_id mid_course_id low_course_id])
  end

end
