# frozen_string_literal: true

# Controller, that handles all pages made directly for students.
class StudentsController < ApplicationController
  before_action :authenticate_student!
  before_action :fetch_data

  def home; end

  def update_selections
    %i[top_selection mid_selection low_selection].each do |selection|
      send(selection).course_id = update_params[selection][:course_id]
    end

    if transactional_save!
      flash.now[:notice] = t('.saved')
    else
      flash.now[:alert] = collect_error_messages
    end

    render 'home'
  end

  private

  def fetch_data
    @grade   = current_student.grade
    @poll    = @grade.running_poll
    @courses = @poll.courses.order(:title)
    top_selection && mid_selection && low_selection
  end

  def selections
    @selections ||= current_student.current_selections
  end

  def top_selection
    @top_selection ||= detect_or_initialize_by_priority(0)
  end

  def mid_selection
    @mid_selection ||= detect_or_initialize_by_priority(1)
  end

  def low_selection
    @low_selection ||= detect_or_initialize_by_priority(2)
  end

  def detect_or_initialize_by_priority(priority)
    selections.detect { |s| s.priority == priority } || selections.new(priority: priority)
  end

  def update_params
    params.require(:student).permit(top_selection: [:course_id],
                                    mid_selection: [:course_id],
                                    low_selection: [:course_id])
  end

  def transactional_save!
    Selection.transaction do
      all_saved = [top_selection, mid_selection, low_selection].map(&:save).all? { |saved| saved }
      raise ActiveRecord::Rollback unless all_saved

      all_saved
    end
  end

  def collect_error_messages
    messages = []

    %i[top_selection mid_selection low_selection].each do |selection|
      send(selection).errors.messages.each do |_, values|
        messages << "#{t("activerecord.attributes.student.#{selection}")}: #{values.join(', ')}"
      end
    end

    messages
  end

end
