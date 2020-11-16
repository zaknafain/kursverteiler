# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
  let(:student)   { create(:student) }
  let(:course)    { create(:course) }
  let(:poll)      { course.poll }
  let(:selection) { create(:selection, :clean, student: student, poll: poll) }

  before(:each) do
    sign_in(student)
  end

  context 'show' do
    render_views

    it 'throws no error if missing poll' do
      expect { get :show, params: { id: student.id } }.to_not raise_error
    end

    it 'throws no error if poll is present' do
      poll

      expect { get :show, params: { id: student.id } }.to_not raise_error
    end
  end

  context 'update' do
    it 'updates the record' do
      expect do
        put :update, params: { id: student.id, student: { current_selection: { top_course_id: course.id } } }
      end.to(change { selection.reload.top_course })
    end
  end
end
