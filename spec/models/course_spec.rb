# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:course) { build(:course) }

  context 'relations' do
    context 'selections' do
      let(:selection)  { create(:selection) }
      let(:top_course) { selection.top_course }
      let(:mid_course) { selection.mid_course }
      let(:low_course) { selection.low_course }

      it 'responds to top selections' do
        expect(course).to respond_to(:top_selections)
      end

      it 'responds to mid selections' do
        expect(course).to respond_to(:mid_selections)
      end

      it 'responds to low selections' do
        expect(course).to respond_to(:low_selections)
      end

      it 'nullifies all its selections on deletion' do
        expect { top_course.destroy }.to change { selection.reload.top_course_id }.from(top_course.id).to(nil)
        expect { mid_course.destroy }.to change { selection.reload.mid_course_id }.from(mid_course.id).to(nil)
        expect { low_course.destroy }.to change { selection.reload.low_course_id }.from(low_course.id).to(nil)
      end
    end

    context 'poll' do
      it 'responds to a poll' do
        expect(course).to respond_to(:poll)
      end
    end

    context 'courses students' do
      let(:student) { create(:student) }

      it 'responds to courses_students' do
        expect(course).to respond_to(:courses_students)
      end

      it 'deletes all courses_students on deletion' do
        course.save!
        course.students << student

        expect { course.destroy }.to change(CoursesStudent, :count).by(-1)
      end
    end

    context 'students' do
      let(:student) { create(:student) }

      it 'responds to students' do
        expect(course).to respond_to(:students)
      end

      it 'has many students through courses_students' do
        expect(course.students).to be_empty

        course.save!
        course.courses_students.create!(student: student)

        expect(course.students).to_not be_empty
        expect(course.students.map(&:id)).to eq([student.id])
      end
    end

    context 'courses' do
      it 'responds to parent_course' do
        expect(course).to respond_to(:parent_course)
      end

      it 'nullifies child courses parent_course_id on deletion' do
        child_course = create(:course, parent_course: course)

        expect { course.destroy }.to change(child_course, :parent_course_id).from(course.id).to(nil)
      end

      it 'responds to child_course' do
        expect(course).to respond_to(:child_course)
      end

      it 'inverts child_course with parent_course' do
        child_course = create(:course, parent_course: course)

        expect(child_course.parent_course).to eq(course)
        expect(course.child_course).to eq(child_course)
      end
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

    it 'NOT validates presence of minimum if guaranteed is true' do
      expect(course).to be_valid

      course.assign_attributes(minimum: nil, guaranteed: true)

      expect(course).to be_valid
    end

    it 'validates minimum to be an integer even if guaranteed is true' do
      expect(course).to be_valid

      course.assign_attributes(minimum: 'Some Value', guaranteed: true)

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

    it 'NOT validates presence of maximum if guaranteed is true' do
      expect(course).to be_valid

      course.assign_attributes(maximum: nil, guaranteed: true)

      expect(course).to be_valid
    end

    it 'validates maximum to be an integer even if guaranteed is true' do
      expect(course).to be_valid

      course.assign_attributes(maximum: 'Some Value', guaranteed: true)

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

    it 'NOT validates presence of parent_course' do
      expect(course.parent_course).to be_nil
      expect(course).to be_valid
    end
  end

  context 'scopes' do
    let!(:course)     { create(:course, poll: poll) }
    let!(:old_course) { create(:course, poll: old_poll) }
    let(:poll)        { create(:poll) }
    let(:old_poll)    { create(:poll, :ended) }

    context 'current' do
      it 'shows all courses for active polls' do
        expect(Course.all.count).to be(2)

        expect(Course.current.count).to be(1)
        expect(Course.current.pluck(:id)).to include(course.id)
      end
    end

    context 'parent_candidates_for' do
      let!(:course_child)     { create(:course, poll: poll, parent_course: old_course_parent) }
      let(:old_course_parent) { create(:course, poll: old_poll) }

      it 'scopes all courses that have no child' do
        expect(Course.parent_candidates_for(course).pluck(:id)).to eq([old_course.id])

        course_child.update(parent_course: nil)

        expect(Course.parent_candidates_for(course).pluck(:id)).to include(old_course.id)
        expect(Course.parent_candidates_for(course).pluck(:id)).to include(old_course_parent.id)
      end

      it 'scopes all courses that are older than the given one' do
        expect(Course.parent_candidates_for(course)).to     eq([old_course])
        expect(Course.parent_candidates_for(old_course)).to eq([])
      end
    end

    context 'not_guaranteed' do
      it 'scopes all courses that are not guaranteed' do
        expect(Course.not_guaranteed.count).to be(2)

        Course.first.update!(guaranteed: true)

        expect(Course.not_guaranteed.count).to be(1)
        expect(Course.not_guaranteed.first.id).to be(Course.second.id)
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
