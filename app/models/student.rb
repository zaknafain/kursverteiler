# frozen_string_literal: true

# Database Model for the regular student user.
# For admins see Admin class.
class Student < ApplicationRecord
  include StudentAdministration
  include SharedUserMethods

  belongs_to :grade
  has_many :selections, dependent: :destroy
  has_many :courses_students, dependent: :delete_all
  has_many :courses, through: :courses_students
  has_one :current_poll, -> { running_at(Time.zone.today) }, through: :grade, source: :polls
  has_one :current_selection, -> { current }, class_name: 'Selection', inverse_of: :student, autosave: true
  has_one :current_top_course, through: :current_selection, source: :top_course
  has_one :current_mid_course, through: :current_selection, source: :mid_course
  has_one :current_low_course, through: :current_selection, source: :low_course

  scope :can_vote_on, lambda { |poll_id|
    includes(grade: [:grades_polls]).where(grade: { grades_polls: { poll_id: poll_id } })
  }
  scope :distributed_in,     ->(poll_id) { includes(:courses).where(courses: { poll_id: poll_id }) }
  scope :not_distributed_in, ->(poll_id) { can_vote_on(poll_id).where.not(id: distributed_in(poll_id)) }

  %i[top mid low].each do |priority|
    define_method(:"current_#{priority}_course=") do |course|
      (current_selection || build_current_selection(poll: current_poll)).public_send(:"#{priority}_course=", course)
    end
  end

  def selection_for(poll)
    selections.detect { |s| s.poll == poll }
  end

end
