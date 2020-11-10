# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Selection, type: :model do
  let(:student)   { create(:student) }
  let(:poll)      { create(:poll) }
  let(:selection) { build(:selection, student: student, poll: poll) }

  context 'validations' do
    it 'presence of student' do
      expect(selection).to be_valid

      selection.student = nil

      expect(selection).to be_invalid
      expect(selection.errors[:student]).to be_present
    end

    it 'presence of poll' do
      expect(selection).to be_valid

      selection.poll = nil

      expect(selection).to be_invalid
      expect(selection.errors[:poll]).to be_present
    end

    it 'NOT presence of courses' do
      expect(selection).to be_valid

      selection.top_course = selection.mid_course = selection.low_course = nil

      expect(selection).to be_valid
    end

    it 'uniqueness of poll scoping student' do
      expect(selection).to be_valid

      create(:selection, poll: poll, student: student)

      expect(selection).to be_invalid
      expect(selection.errors[:poll]).to be_present

      selection.poll = create(:poll, :ended)

      expect(selection).to be_valid
    end
  end

  context 'scopes' do
    let(:old_poll)       { create(:poll, :ended) }
    let!(:old_selection) { create(:selection, student: student, poll: old_poll) }

    context 'current' do
      it 'returns selections of running polls' do
        selection.save!

        expect(Selection.count).to be(2)
        expect(Selection.pluck(:id)).to include(selection.id)
        expect(Selection.pluck(:id)).to include(old_selection.id)
        expect(Selection.current.count).to be(1)
        expect(Selection.current.first.id).to be(selection.id)
      end
    end
  end
end
