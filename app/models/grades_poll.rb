# frozen_string_literal: true

# Database Model for the Joined Table of Grades and Polls
class GradesPoll < ApplicationRecord
  belongs_to :grade
  belongs_to :poll

  validates :grade_id, uniqueness: { scope: :poll_id }

end
