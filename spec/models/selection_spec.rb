# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Selection, type: :model do
  let(:student)   { create(:student) }
  let(:course)    { create(:course) }
  let(:selection) { build(:selection, student: student, course: course) }

  context 'validations' do
    it 'presence of student' do
      expect(selection).to be_valid

      selection.student = nil

      expect(selection).to be_invalid
      expect(selection.errors[:student]).to be_present
    end

    it 'presence of course' do
      expect(selection).to be_valid

      selection.course = nil

      expect(selection).to be_invalid
      expect(selection.errors[:course]).to be_present
    end

    it 'uniqueness of student and course' do
      expect(selection).to be_valid

      create(:selection, student: student, course: course, priority: selection.priority)
      expect(selection).to be_invalid
      expect(selection.errors[:course]).to be_present
    end

    it 'validates priority to be 0 to 2' do
      expect(selection).to be_valid

      selection.priority = -1

      expect(selection).to be_invalid
      expect(selection.errors[:priority]).to be_present

      selection.priority = 1

      expect(selection).to be_valid

      selection.priority = 2

      expect(selection).to be_valid

      selection.priority = 3

      expect(selection).to be_invalid
      expect(selection.errors[:priority]).to be_present
    end
  end

  context 'scopes' do
    let(:old_poll)       { create(:poll, :ended) }
    let(:old_course)     { create(:course, poll: old_poll) }
    let!(:selection)     { create(:selection, student: student) }
    let!(:old_selection) { create(:selection, student: student, course: old_course) }

    context 'current' do
      it 'returns selections of running polls' do
        expect(Selection.count).to be(2)
        expect(Selection.pluck(:id)).to include(selection.id)
        expect(Selection.pluck(:id)).to include(old_selection.id)
        expect(Selection.current.count).to be(1)
        expect(Selection.current.first.id).to be(selection.id)
      end
    end
  end
end
