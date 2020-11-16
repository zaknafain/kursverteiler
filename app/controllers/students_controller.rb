# frozen_string_literal: true

# Controller, that handles all pages made directly for students.
class StudentsController < ApplicationController
  before_action :authenticate_student!
  before_action :fetch_data

  def update
    if selection.update(update_params[:current_selection])
      flash.now[:notice] = t('.saved')
    else
      flash.now[:alert] = collect_error_messages
    end

    render :show
  end

  private

  def fetch_data
    @grade   = current_student.grade
    @poll    = @grade.running_poll
    @courses = @poll.courses.order(:title)
    selection
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

  def collect_error_messages
    messages = []

    selection.errors.messages.each do |_, values|
      messages << values.join(', ')
    end

    messages
  end

end
