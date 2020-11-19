# frozen_string_literal: true

# Database Model for classes the student can choose.
class Course < ApplicationRecord
  include CourseAdministration

  has_rich_text :description

  belongs_to :poll
  has_many :top_selections, dependent: :nullify, class_name: 'Selection',
                            foreign_key: :top_course_id, inverse_of: :top_course
  has_many :mid_selections, dependent: :nullify, class_name: 'Selection',
                            foreign_key: :mid_course_id, inverse_of: :mid_course
  has_many :low_selections, dependent: :nullify, class_name: 'Selection',
                            foreign_key: :low_course_id, inverse_of: :low_course

  validates :title, presence: true
  validates :guaranteed, inclusion: { in: [true, false] }
  validates :minimum, :maximum, numericality: { only_integer: true, greater_than: 0, less_than: 100 }
  validate  :minimum_is_lesser_or_equal_than_maximum

  scope :current, -> { where(poll: Poll.running_at(Time.zone.today)) }

  def selections
    Selection.where(top_course: id).or(Selection.where(mid_course: id)).or(Selection.where(low_course: id))
  end

  private

  def minimum_is_lesser_or_equal_than_maximum
    return unless minimum && maximum
    return unless minimum > maximum

    errors.add(:minimum, 'must be lower than the maximum')
    errors.add(:maximum, 'must be higher than the minimum')
  end

end
