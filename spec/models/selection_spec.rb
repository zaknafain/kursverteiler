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

    it 'uniqueness of courses' do
      expect(selection).to be_valid
      course = selection.mid_course

      selection.mid_course = selection.top_course

      expect(selection).to be_invalid
      expect(selection.errors[:mid_course]).to be_present

      selection.top_course = selection.low_course

      expect(selection).to be_invalid
      expect(selection.errors[:low_course]).to be_present

      selection.low_course = course

      expect(selection).to be_valid
    end

    it 'uniqueness of courses except nil values' do
      expect(selection).to be_valid

      selection.low_course = selection.mid_course = nil

      expect(selection).to be_valid

      selection.top_course = nil

      expect(selection).to be_valid
    end

    it 'prefer top course before all' do
      expect(selection).to be_valid

      selection.top_course = nil

      expect(selection).to be_invalid
      expect(selection.errors[:top_course]).to be_present
    end

    it 'prefer mid course before low course' do
      expect(selection).to be_valid

      selection.mid_course = nil

      expect(selection).to be_invalid
      expect(selection.errors[:mid_course]).to be_present
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

  context '#prio_for?' do
    let(:selection) { create(:selection) }

    it 'returns nil if the requested course has no prio' do
      course = create(:course)

      expect(selection.prio_for?(course)).to be_falsey
    end

    it 'returns :top if the requested course is top prio' do
      expect(selection.prio_for?(selection.top_course)).to be(:top)
    end

    it 'returns :mid if the requested course is mid prio' do
      expect(selection.prio_for?(selection.mid_course)).to be(:mid)
    end

    it 'returns :low if the requested course is low prio' do
      expect(selection.prio_for?(selection.low_course)).to be(:low)
    end

    it 'returns nil if there are no courses selected' do
      selection = create(:selection, top_course: nil, mid_course: nil, low_course: nil)
      course    = create(:course)

      expect(selection.prio_for?(course)).to be_falsey
    end

    it 'returns false if the requested course is nil' do
      expect(selection.prio_for?(nil)).to be_falsey
    end
  end
end
