# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Student, type: :model do
  let(:student) { build(:student) }

  context 'relations' do
    context 'selections' do
      let!(:selection)     { create(:selection, student: student) }
      let!(:old_selection) { create(:selection, student: student, poll: old_poll) }
      let(:old_poll)       { create(:poll, :ended) }

      it 'destroys all its selections on deletion' do
        expect { student.destroy }.to change(Selection, :count).by(-2)
      end

      it 'has one current selection' do
        expect(student.selections.count).to be(2)
        expect(student.selections.pluck(:id)).to include(selection.id)
        expect(student.selections.pluck(:id)).to include(old_selection.id)

        expect(student.current_selection.id).to be(selection.id)
      end
    end

    context 'current courses' do
      let!(:selection) { create(:selection, student: student) }

      it 'has a current top course through current selection' do
        expect(student.current_top_course.id).to be(selection.top_course.id)
      end

      it 'has a current mid course through current selection' do
        expect(student.current_mid_course.id).to be(selection.mid_course.id)
      end

      it 'has a current low course through current selection' do
        expect(student.current_low_course.id).to be(selection.low_course.id)
      end

      it 'returns nil if there is no current selection' do
        student = build(:student)

        expect(student.current_top_course).to be_nil
      end

      it 'returns nil if the selection has no course' do
        selection.update(low_course: nil)

        expect(student.current_low_course).to be_nil
      end

      it 'can be assigned and saved' do
        expect(student.current_top_course.id).to be(selection.top_course.id)

        expect do
          student.current_top_course = selection.mid_course
          student.current_mid_course = selection.low_course
          student.current_low_course = selection.top_course
          student.save!
        end.to(change { selection.reload.top_course.id })
      end

      it 'will not destroy the selection if nil is assigned' do
        expect(student.current_selection.id).to_not be_nil

        expect do
          student.current_top_course = nil
          student.current_mid_course = nil
          student.current_low_course = nil
          student.save!
        end.to_not(change { selection.reload.id })
      end
    end

    context 'current poll' do
      let!(:poll) { create(:poll, grades: [student.grade]) }

      it 'has one current poll' do
        student.save!

        expect(student.current_poll.id).to be(poll.id)
      end
    end
  end

  context 'validations' do
    it 'validates presence of first_name' do
      expect(student).to be_valid

      student.first_name = nil

      expect(student).to be_invalid
      expect(student.errors[:first_name]).to be_present

      student.first_name = ''

      expect(student).to be_invalid
      expect(student.errors[:first_name]).to be_present
    end

    it 'validates presence of last_name' do
      expect(student).to be_valid

      student.last_name = nil

      expect(student).to be_invalid
      expect(student.errors[:last_name]).to be_present

      student.last_name = ''

      expect(student).to be_invalid
      expect(student.errors[:last_name]).to be_present
    end

    it 'validates presence of email' do
      expect(student).to be_valid

      student.email = nil

      expect(student).to be_invalid
      expect(student.errors[:email]).to be_present

      student.email = ''

      expect(student).to be_invalid
      expect(student.errors[:email]).to be_present
    end
  end
end
