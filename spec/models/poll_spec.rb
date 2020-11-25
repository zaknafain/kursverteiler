# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Poll, type: :model do
  context 'relations' do
    let(:poll) { create(:poll) }

    it 'has courses' do
      expect(poll).to respond_to(:courses)
    end

    it 'destroys all its courses on deletion' do
      create(:course, poll: poll)

      expect { poll.destroy }.to change(Course, :count).by(-1)
    end

    it 'has selections' do
      expect(poll).to respond_to(:selections)
    end

    it 'destroys all its selections on deletion' do
      create(:selection, poll: poll)

      expect { poll.destroy }.to change(Selection, :count).by(-1)
    end

    it 'has grades_polls' do
      expect(poll).to respond_to(:grades_polls)
    end

    it 'deletes all its grades_polls on deletion' do
      poll.grades << create(:grade)

      expect { poll.destroy }.to change(GradesPoll, :count).by(-1)
    end

    it 'has grades' do
      expect(poll).to respond_to(:grades)
    end

    it 'has students' do
      expect(poll).to respond_to(:students)
    end
  end

  context 'validations' do
    let(:poll) { build(:poll) }

    it 'validates presence of title' do
      expect(poll).to be_valid

      poll.title = nil

      expect(poll).to be_invalid
      expect(poll.errors[:title]).to be_present

      poll.title = ''

      expect(poll).to be_invalid
      expect(poll.errors[:title]).to be_present
    end

    it 'validates presence of valid_from' do
      expect(poll).to be_valid

      poll.valid_from = nil

      expect(poll).to be_invalid
      expect(poll.errors[:valid_from]).to be_present
    end

    it 'validates presence of valid_until' do
      expect(poll).to be_valid

      poll.valid_until = nil

      expect(poll).to be_invalid
      expect(poll.errors[:valid_until]).to be_present
    end

    it 'validates valid_from to be before valid_until' do
      expect(poll).to be_valid

      poll.valid_from = poll.valid_until

      expect(poll).to be_invalid
      expect(poll.errors[:valid_from]).to be_present
      expect(poll.errors[:valid_until]).to be_present

      poll.valid_from = poll.valid_until + 1.hour

      expect(poll).to be_invalid
      expect(poll.errors[:valid_from]).to be_present
      expect(poll.errors[:valid_until]).to be_present
    end
  end

  context 'scopes' do
    let!(:old_poll)     { create(:poll, :ended) }
    let!(:current_poll) { create(:poll) }
    let!(:future_poll)  { create(:poll, :future) }

    context 'running_at' do
      it 'includes all polls with valid_from before and valid_until after the requested date' do
        expect(Poll.running_at(Time.zone.today).count).to be(1)
        expect(Poll.running_at(Time.zone.today).first.id).to be(current_poll.id)
        expect(Poll.running_at(12.months.ago).count).to be(1)
        expect(Poll.running_at(12.months.ago).first.id).to be(old_poll.id)
        expect(Poll.running_at(12.months.from_now).count).to be(1)
        expect(Poll.running_at(12.months.from_now).first.id).to be(future_poll.id)
      end

      it 'returns the current polls by default' do
        expect(Poll.running_at.count).to be(1)
        expect(Poll.running_at.first.id).to be(current_poll.id)
      end
    end

    context 'future' do
      it 'includes all poll with valid_from after the requested date' do
        expect(Poll.future(Time.zone.today).count).to be(1)
        expect(Poll.future(Time.zone.today).first.id).to be(future_poll.id)
        expect(Poll.future(7.months.ago).count).to be(2)
        expect(Poll.future(7.months.ago).pluck(:id)).to include(current_poll.id)
        expect(Poll.future(7.months.ago).pluck(:id)).to include(future_poll.id)
      end

      it 'returns the future poll by default' do
        expect(Poll.future.count).to be(1)
        expect(Poll.future.first.id).to be(future_poll.id)
      end
    end
  end

  context '#grades_count' do
    let(:grade_a) { create(:grade) }
    let(:grade_b) { create(:grade) }
    let(:poll)    { create(:poll, grades: [grade_a, grade_b]) }

    it 'returns the amount of related grades' do
      expect(poll.grades_count).to be(2)
    end
  end
end
