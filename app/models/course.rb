# frozen_string_literal: true

# Database Model for classes the student can choose.
class Course < ApplicationRecord
  include CourseAdministration

  belongs_to :poll
  has_many   :selections, dependent: :destroy

  validates :poll, :title, presence: true
  validates :mandatory, inclusion: { in: [true, false] }
  validates :minimum, :maximum, numericality: { only_integer: true, greater_than: 0, less_than: 100 }
  validate  :minimum_is_lesser_or_equal_than_maximum

  scope :current, -> { where(poll: Poll.running_at(Time.zone.today)) }

  private

  def minimum_is_lesser_or_equal_than_maximum
    return unless minimum && maximum
    return unless minimum > maximum

    errors.add(:minimum, 'must be lower than the maximum')
    errors.add(:maximum, 'must be higher than the minimum')
  end
end
