# frozen_string_literal: true

# Database model for the classes the student is part of.
class Grade < ApplicationRecord
  include GradeAdministration

  has_many :grades_polls, dependent: :delete_all
  has_many :polls,        through:   :grades_polls
  has_many :students,     dependent: :destroy
  has_one  :running_poll, -> { running_at(Time.zone.today) }, inverse_of: :grades

  validates :name, uniqueness: { case_sensitive: false }

end
