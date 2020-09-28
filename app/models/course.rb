# frozen_string_literal: true

# Database Model for classes the student can choose.
class Course < ApplicationRecord
  include CourseAdministration

  belongs_to :poll

  validates :poll, :title, presence: true
  validates :minimum, :maximum, numericality: { only_integer: true, greater_than: 0, less_than: 100 }
  validate :minimum_is_lesser_than_maximum

  private

  def minimum_is_lesser_than_maximum
    return unless minimum && maximum
    return unless minimum > maximum

    errors.add(:minimum, 'must be lower than the maximum')
    errors.add(:maximum, 'must be higher than the minimum')
  end
end