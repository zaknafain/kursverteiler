# frozen_string_literal: true

# Database Model for the Joined Table of Courses and Students
class CoursesStudent < ApplicationRecord
  belongs_to :course
  belongs_to :student

  validates :student_id, uniqueness: { scope: :course_id }

end
