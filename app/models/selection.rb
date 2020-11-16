# frozen_string_literal: true

# Represents the actual course selection of the student of a poll.
class Selection < ApplicationRecord
  include SelectionAdministration

  belongs_to :student
  belongs_to :poll
  belongs_to :top_course, class_name: 'Course', optional: true
  belongs_to :mid_course, class_name: 'Course', optional: true
  belongs_to :low_course, class_name: 'Course', optional: true

  validates :poll, uniqueness: { scope: [:student] }

  scope :current, -> { where(poll: Poll.running_at(Time.zone.today)) }

  def prio_for?(course)
    return false unless course

    %i[top mid low].detect do |prio|
      prio if public_send("#{prio}_course_id") == course.id
    end
  end

end
