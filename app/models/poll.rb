# frozen_string_literal: true

# Database Model for a poll in which students may choose courses.
class Poll < ApplicationRecord
  include PollAdministration

  has_rich_text :description

  has_many :grades_polls, dependent: :delete_all
  has_many :grades,       through:   :grades_polls
  has_many :students, -> { includes(:current_selection) }, through: :grades
  has_many :courses,      dependent: :destroy
  has_many :selections,   dependent: :destroy

  scope :running_at, ->(date = Time.zone.today) { where('valid_from <= ? AND polls.valid_until >= ?', date, date) }
  scope :future,     ->(date = Time.zone.today) { where('valid_from > ?', date) }
  scope :past,       ->(date = Time.zone.today) { where('polls.valid_until < ?', date) }

  validates :title, :valid_from, :valid_until, presence: true
  validate  :interval_to_be_positive

  def grades_count
    grades.length
  end

  def students_without_selection
    students.select { |s| s.selection_for(self)&.top_course_id.nil? }
  end

  private

  def interval_to_be_positive
    return if valid_from.blank? || valid_until.blank?
    return if valid_from < valid_until

    errors.add(:valid_from, 'must be before valid_until')
    errors.add(:valid_until, 'must be after valid_from')
  end

end
