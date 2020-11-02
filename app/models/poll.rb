# frozen_string_literal: true

# Database Model for a poll in which students may choose courses.
class Poll < ApplicationRecord
  include PollAdministration

  has_many :grades_polls, dependent: :delete_all
  has_many :grades,       through:   :grades_polls
  has_many :courses,      dependent: :destroy
  has_many :selections,   through:   :courses

  scope :running_at, ->(date = Time.zone.today) { where('valid_from <= ? AND valid_until >= ?', date, date) }

  validates :title, :valid_from, :valid_until, presence: true
  validate  :interval_to_be_positive

  def grades_count
    grades.length
  end

  private

  def interval_to_be_positive
    return if valid_from.blank? || valid_until.blank?
    return if valid_from < valid_until

    errors.add(:valid_from, 'must be before valid_until')
    errors.add(:valid_until, 'must be after valid_from')
  end

end
