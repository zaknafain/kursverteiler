# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GradesPoll, type: :model do
  context 'validations' do
    let(:poll)        { create(:poll) }
    let(:grade)       { create(:grade) }
    let(:grades_poll) { build(:grades_poll, poll: poll, grade: grade) }

    it 'validates presence of grade_id' do
      expect(grades_poll).to be_valid

      grades_poll.grade = nil

      expect(grades_poll).to be_invalid
      expect(grades_poll.errors[:grade]).to be_present
    end

    it 'validates presence of poll_id' do
      expect(grades_poll).to be_valid

      grades_poll.poll = nil

      expect(grades_poll).to be_invalid
      expect(grades_poll.errors[:poll]).to be_present
    end

    it 'validates uniqueness of grade_id and poll_id' do
      expect(grades_poll).to be_valid

      create(:grades_poll, poll: poll, grade: grade)

      expect(grades_poll).to be_invalid
      expect(grades_poll.errors[:grade_id]).to be_present
    end
  end
end
