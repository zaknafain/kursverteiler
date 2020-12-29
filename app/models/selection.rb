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
  validate :mid_course_not_to_be_top_course
  validate :low_course_not_to_be_top_or_mid_course
  validate :top_course_to_be_set_first
  validate :mid_course_to_be_set_before_low_course

  scope :current, -> { where(poll: Poll.running_at(Time.zone.today)) }

  def prio_for(course)
    return unless course

    %i[top mid low].detect do |prio|
      prio if public_send("#{prio}_course_id") == course.id
    end
  end

  private

  def top_course_to_be_set_first
    return if top_course.present?
    return if [mid_course, low_course].all?(&:nil?)

    errors.add(:top_course, I18n.t('activerecord.errors.models.selection.attributes.top_course.neglected'))
  end

  def mid_course_to_be_set_before_low_course
    return if mid_course.present?
    return if low_course.nil?

    errors.add(:mid_course, I18n.t('activerecord.errors.models.selection.attributes.mid_course.neglected'))
  end

  def mid_course_not_to_be_top_course
    return if mid_course.nil? || mid_course != top_course

    errors.add(:mid_course, I18n.t('activerecord.errors.models.selection.attributes.mid_course.taken'))
  end

  def low_course_not_to_be_top_or_mid_course
    return if low_course.nil? || (low_course != top_course && low_course != mid_course)

    errors.add(:low_course, I18n.t('activerecord.errors.models.selection.attributes.low_course.taken'))
  end

end
