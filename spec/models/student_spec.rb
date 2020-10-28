# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Student, type: :model do
  let(:student) { build(:student) }

  context 'relations' do
    let!(:selection)     { create(:selection, student: student, poll: poll) }
    let!(:old_selection) { create(:selection, student: student, poll: old_poll) }
    let(:poll)           { create(:poll) }
    let(:old_poll)       { create(:poll, valid_from: 18.months.ago, valid_until: 6.months.ago) }

    it 'destroys all its selections on deletion' do
      expect { student.destroy }.to change(Selection, :count).by(-2)
    end

    it 'has many current selections' do
      expect(student.selections.count).to be(2)
      expect(student.selections.pluck(:id)).to include(selection.id)
      expect(student.selections.pluck(:id)).to include(old_selection.id)

      expect(student.current_selections.count).to be(1)
      expect(student.current_selections.pluck(:id)).to include(selection.id)
    end

    it 'has one current top selection' do
      expect(student.selections.count).to be(2)
      expect(student.selections.pluck(:id)).to include(selection.id)
      expect(student.selections.pluck(:id)).to include(old_selection.id)

      expect(student.top_selection.id).to be(selection.id)
    end

    it 'has one current mid selection' do
      mid_selection = create(:selection, student: student, priority: 1, poll: poll)

      expect(student.selections.count).to be(3)
      expect(student.selections.pluck(:id)).to include(selection.id)
      expect(student.selections.pluck(:id)).to include(mid_selection.id)

      expect(student.mid_selection.id).to be(mid_selection.id)
    end

    it 'has one current low selection' do
      low_selection = create(:selection, student: student, priority: 2, poll: poll)

      expect(student.selections.count).to be(3)
      expect(student.selections.pluck(:id)).to include(selection.id)
      expect(student.selections.pluck(:id)).to include(low_selection.id)

      expect(student.low_selection.id).to be(low_selection.id)
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
  end
end
