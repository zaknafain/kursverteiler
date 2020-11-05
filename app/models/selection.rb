# frozen_string_literal: true

# Represents the actual course selection of the student of a poll.
class Selection < ApplicationRecord
  include SelectionAdministration

  belongs_to :student
  belongs_to :course
  has_one :poll, through: :course

  validates :course,   uniqueness:   { scope: [:student] }
  validates :priority, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 3 }
  # priority: 0 -> Top Prio / priority: 1 -> Medium Prio / priority: 2 -> Low Prio
  validate :uniqueness_of_poll_priority_and_student

  scope :top_priority,    -> { where(priority: 0) }
  scope :medium_priority, -> { where(priority: 1) }
  scope :low_priority,    -> { where(priority: 2) }
  scope :current,         -> { where(course: Course.where(poll: Poll.running_at(Time.zone.today))) }

  private

  def uniqueness_of_poll_priority_and_student
    return if course&.poll.blank?

    courses = Course.where(poll: course.poll)
    scope   = persisted? ? Selection.where.not(id: id) : Selection.all
    return unless scope.exists?(course: courses, priority: priority, student: student)

    errors.add(:priority, :taken)
  end

end
