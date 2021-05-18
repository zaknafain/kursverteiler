# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Grade, type: :model do
  let(:grade) { build(:grade) }

  context 'relations' do
    let(:grade) { create(:grade) }

    it 'destroys all its students on deletion' do
      create(:student, grade: grade)

      expect { grade.destroy }.to change(Student, :count).by(-1)
    end

    it 'deletes all grades_polls on deletion' do
      grade.polls << create(:poll)

      expect { grade.destroy }.to change(GradesPoll, :count).by(-1)
    end
  end

  context 'validations' do
    it 'uniqueness of name' do
      expect(grade).to be_valid

      create(:grade, name: grade.name)

      expect(grade).to be_invalid
      expect(grade.errors[:name]).to be_present
    end

    it 'uniqueness of name case insensitive' do
      expect(grade).to be_valid

      create(:grade, name: grade.name.upcase)

      expect(grade).to be_invalid
      expect(grade.errors[:name]).to be_present
    end

    it 'presence of name' do
      expect(grade).to be_valid

      grade.name = ''

      expect(grade).to be_invalid
      expect(grade.errors[:name]).to be_present

      grade.name = nil

      expect(grade).to be_invalid
      expect(grade.errors[:name]).to be_present
    end
  end

  context 'hooks' do
    it 'calls the set_valid_until method before validation' do
      expect(grade).to receive(:set_valid_until).and_call_original
      expect(grade).to be_valid
    end
  end

  context '#student_count' do
    it 'fetches the latest amount of students' do
      3.times { create(:student, grade: grade) }

      expect(grade.student_count).to be(3)
    end
  end

  context '#running_poll' do
    let(:grade)    { create(:grade, polls: [poll, old_poll]) }
    let(:poll)     { create(:poll) }
    let(:old_poll) { create(:poll, :ended) }

    it 'has one running poll' do
      expect(grade.polls.count).to     be(2)
      expect(grade.running_poll.id).to be(poll.id)
    end
  end
end
