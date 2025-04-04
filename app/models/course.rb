# frozen_string_literal: true

# Database Model for classes the student can choose.
class Course < ApplicationRecord
  has_rich_text :description

  belongs_to :poll
  belongs_to :parent_course, class_name: 'Course', inverse_of: :child_course, optional: true
  has_one    :child_course, dependent: :nullify, class_name: 'Course',
                            foreign_key: :parent_course_id, inverse_of: :parent_course
  has_many :courses_students, dependent: :delete_all
  has_many :students, through: :courses_students
  has_many :top_selections, dependent: :nullify, class_name: 'Selection',
                            foreign_key: :top_course_id, inverse_of: :top_course
  has_many :mid_selections, dependent: :nullify, class_name: 'Selection',
                            foreign_key: :mid_course_id, inverse_of: :mid_course
  has_many :low_selections, dependent: :nullify, class_name: 'Selection',
                            foreign_key: :low_course_id, inverse_of: :low_course

  validates :title, presence: true
  validates :minimum, :maximum, presence: true, unless: :guaranteed?
  validates :guaranteed, inclusion: { in: [true, false] }
  validates :minimum, :maximum, numericality: { only_integer: true, greater_than: 0, less_than: 100, allow_nil: true }
  validate  :minimum_is_lesser_or_equal_than_maximum

  scope :not_guaranteed, -> { where(guaranteed: false) }
  scope :current, -> { where(poll: Poll.running_at(Time.zone.today)) }
  scope :parent_candidates_for, lambda { |course|
    joins(:poll).includes(:child_course)
                .where(child_courses_courses: { id: nil })
                .where('polls.valid_until < ?', course.poll.valid_from)
  }

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
