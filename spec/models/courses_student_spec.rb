# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CoursesStudent, type: :model do
  context 'validations' do
    let(:course)          { create(:course) }
    let(:student)         { create(:student) }
    let(:courses_student) { build(:courses_student, course: course, student: student) }

    it 'validates presence of student_id' do
      expect(courses_student).to be_valid

      courses_student.student = nil

      expect(courses_student).to be_invalid
      expect(courses_student.errors[:student]).to be_present
    end

    it 'validates presence of course_id' do
      expect(courses_student).to be_valid

      courses_student.course = nil

      expect(courses_student).to be_invalid
      expect(courses_student.errors[:course]).to be_present
    end

    it 'validates uniqueness of student_id and course_id' do
      expect(courses_student).to be_valid

      create(:courses_student, course: course, student: student)

      expect(courses_student).to be_invalid
      expect(courses_student.errors[:student_id]).to be_present
    end
  end
end
