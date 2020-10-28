# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Poll, type: :model do
  let(:poll) { build(:poll) }

  context 'relations' do
    let(:selection) { create(:selection) }
    let(:course)    { selection.course }
    let!(:poll)     { course.poll }

    it 'destroys all its courses on deletion' do
      expect { poll.destroy }.to change(Course, :count).by(-1)
    end

    it 'destroys all its selections on deletion' do
      expect { poll.destroy }.to change(Selection, :count).by(-1)
    end
  end

  context 'validations' do
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
    context 'running_at' do
      let!(:old_poll)     { create(:poll, :ended) }
      let!(:current_poll) { create(:poll) }
      let!(:future_poll)  { create(:poll, valid_from: 6.months.from_now, valid_until: 18.months.from_now) }

      it 'includes all polls with valid_from before and valid_until after the requested date' do
        expect(Poll.running_at(Time.zone.today).count).to be(1)
        expect(Poll.running_at(Time.zone.today).first.id).to be(current_poll.id)
        expect(Poll.running_at(12.months.ago).count).to be(1)
        expect(Poll.running_at(12.months.ago).first.id).to be(old_poll.id)
        expect(Poll.running_at(12.months.from_now).count).to be(1)
        expect(Poll.running_at(12.months.from_now).first.id).to be(future_poll.id)
      end
    end
  end
end
