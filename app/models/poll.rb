# frozen_string_literal: true

# Database Model for a poll in which students may choose courses.
class Poll < ApplicationRecord
  include PollAdministration

  has_many :courses

  scope :running_at, ->(time) { where('valid_from <= ? AND valid_until >= ?', time, time) }

  validates :title, :valid_from, :valid_until, presence: true
  validate :time_frame_to_be_positive

  private

  def time_frame_to_be_positive
    return unless valid_from && valid_until
    return unless valid_from > valid_until

    errors.add(:valid_from, "can't be after valid_until")
    errors.add(:valid_until, "can't be before valid_from")
  end
end
