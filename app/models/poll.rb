# frozen_string_literal: true

# Database Model for a poll in which students may choose courses.
class Poll < ApplicationRecord
  include PollAdministration

  has_many :courses,    dependent: :destroy
  has_many :selections, dependent: :destroy

  scope :running_at, ->(date = DateTime.now) { where('valid_from <= ? AND valid_until >= ?', date, date) }

  validates :title, :valid_from, :valid_until, presence: true
  validate  :time_frame_to_be_positive

  private

  def time_frame_to_be_positive
    return unless valid_from && valid_until
    return unless valid_from >= valid_until

    errors.add(:valid_from, 'must be before valid_until')
    errors.add(:valid_until, 'must be after valid_from')
  end
end
