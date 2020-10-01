# frozen_string_literal: true

# Represents the actual course selection of the student of a poll.
class Selection < ApplicationRecord
  include SelectionAdministration

  belongs_to :poll
  belongs_to :student
  belongs_to :course

  validates :priority, uniqueness:   { scope: %i[student poll] }
  validates :priority, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 3 }
  # priority: 0 -> Top Prio / priority: 1 -> Medium Prio / priority: 2 -> Low Prio

  scope :top_priority,    -> { where(priority: 0) }
  scope :medium_priority, -> { where(priority: 1) }
  scope :low_priority,    -> { where(priority: 2) }
end
