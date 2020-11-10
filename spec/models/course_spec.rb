# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:course) { build(:course) }

  context 'relations' do
    let(:selection)   { create(:selection) }
    let!(:top_course) { selection.top_course }
    let!(:mid_course) { selection.mid_course }
    let!(:low_course) { selection.low_course }

    it 'nullifies all its selections on deletion' do
      expect { top_course.destroy }.to change { selection.reload.top_course_id }.from(top_course.id).to(nil)
      expect { mid_course.destroy }.to change { selection.reload.mid_course_id }.from(mid_course.id).to(nil)
      expect { low_course.destroy }.to change { selection.reload.low_course_id }.from(low_course.id).to(nil)
    end
  end

  context 'validations' do
    it 'validates presence of title' do
      expect(course).to be_valid

      course.title = nil

      expect(course).to be_invalid
      expect(course.errors[:title]).to be_present

      course.title = ''

      expect(course).to be_invalid
      expect(course.errors[:title]).to be_present
    end

    it 'validates presence of poll' do
      expect(course).to be_valid

      course.poll = nil

      expect(course).to be_invalid
      expect(course.errors[:poll]).to be_present
    end

    it 'validates presence of minimum' do
      expect(course).to be_valid

      course.minimum = nil

      expect(course).to be_invalid
      expect(course.errors[:minimum]).to be_present
    end

    it 'validates minimum to be between 0 and 100' do
      course.maximum = 99
      expect(course).to be_valid

      course.minimum = 0

      expect(course).to be_invalid
      expect(course.errors[:minimum]).to be_present

      course.minimum = 1

      expect(course).to be_valid

      course.minimum = 99

      expect(course).to be_valid

      course.minimum = 100

      expect(course).to be_invalid
      expect(course.errors[:minimum]).to be_present
    end

    it 'validates presence of maximum' do
      expect(course).to be_valid

      course.maximum = nil

      expect(course).to be_invalid
      expect(course.errors[:maximum]).to be_present
    end

    it 'validates maximum to be between 0 and 100' do
      course.minimum = 1
      expect(course).to be_valid

      course.maximum = 0

      expect(course).to be_invalid
      expect(course.errors[:maximum]).to be_present

      course.maximum = 1

      expect(course).to be_valid

      course.maximum = 99

      expect(course).to be_valid

      course.maximum = 100

      expect(course).to be_invalid
      expect(course.errors[:maximum]).to be_present
    end

    it 'validates maximum to be greater than minimum' do
      expect(course).to be_valid

      course.minimum = course.maximum + 1

      expect(course).to be_invalid
      expect(course.errors[:maximum]).to be_present
      expect(course.errors[:minimum]).to be_present
    end

    it 'validates guaranteed to be false or true' do
      expect(course).to be_valid

      course.guaranteed = nil
      expect(course).to be_invalid
      expect(course.errors[:guaranteed]).to be_present
    end
  end

  context 'scopes' do
    context 'current' do
      let!(:course)     { create(:course, poll: poll) }
      let!(:old_course) { create(:course, poll: old_poll) }
      let(:poll)        { create(:poll) }
      let(:old_poll)    { create(:poll, :ended) }

      it 'shows all courses for active polls' do
        expect(Course.all.count).to be(2)

        expect(Course.current.count).to be(1)
        expect(Course.current.pluck(:id)).to include(course.id)
      end
    end
  end

  context '#selections' do
    let!(:top_selection) { create(:selection, top_course: course) }
    let!(:mid_selection) { create(:selection, mid_course: course) }
    let!(:low_selection) { create(:selection, low_course: course) }

    it 'returns top, mid and low selections' do
      expect(course.selections.length).to be(3)
      expect(course.selections.map(&:id)).to include(top_selection.id)
      expect(course.selections.map(&:id)).to include(mid_selection.id)
      expect(course.selections.map(&:id)).to include(low_selection.id)
    end
  end
end
