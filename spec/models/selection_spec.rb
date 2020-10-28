# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Selection, type: :model do
  let(:student)   { create(:student) }
  let(:poll)      { create(:poll) }
  let(:selection) { build(:selection, student: student, poll: poll) }

  context 'validations' do
    it 'presence of poll' do
      expect(selection).to be_valid

      selection.poll = nil

      expect(selection).to be_invalid
      expect(selection.errors[:poll]).to be_present
    end

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

    it 'uniqueness of poll, student and priority' do
      expect(selection).to be_valid

      create(:selection, poll: poll, student: student)

      expect(selection).to be_invalid
      expect(selection.errors[:priority]).to be_present
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
    let!(:selection)     { create(:selection, student: student, poll: poll) }
    let!(:old_selection) { create(:selection, student: student, poll: old_poll) }

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
