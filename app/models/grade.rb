# frozen_string_literal: true

# Database model for the classes the student is part of.
class Grade < ApplicationRecord
  include GradeAdministration

  has_many :grades_polls, dependent: :delete_all
  has_many :polls,        through:   :grades_polls
  has_many :students,     dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  before_validation :set_valid_until

  def student_count
    students.length
  end

  def running_poll
    polls.running_at(Time.zone.today).first
  end

  def set_valid_until
    self.valid_until = 3.years.from_now if valid_until.nil?
  end

end
