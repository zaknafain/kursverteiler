# frozen_string_literal: true

# Main Helper for RailsAdmin related views
module RailsAdminHelper
  def classes_for(course)
    classes = %w[course alert]

    classes << if course.guaranteed?
                 'alert-info'
               else
                 student_count_to_course_class(course.students.length, course)
               end

    classes.join(' ')
  end

  def distribution_indicator_by(student, poll)
    %i[top mid low].map do |priority|
      concat selection_indicator_by(student, poll, priority)
    end
  end

  def selection_indicator_by(student, poll, priority)
    tag.div(class: "selection-indicator #{selection_color_class_by(student, poll, priority)}") do
      selection_icon_by(student, poll, priority)
    end
  end

  def selection_icon_by(student, poll, priority)
    tag.i('', class: selection_icon_class_by(student, poll, priority))
  end

  def selection_icon_class_by(student, poll, priority)
    selection_id = student.selection_for(poll)&.send("#{priority}_course_id")

    return 'icon-remove-circle' if selection_id.blank?

    student.courses.any? { |c| c.id == selection_id } ? 'icon-ok-sign' : 'icon-remove'
  end

  def selection_color_class_by(student, poll, priority)
    if student.selection_for(poll)&.send("#{priority}_course_id").present?
      priority_to_indicator(priority)
    else
      'text-muted'
    end
  end

  def priority_to_indicator(priority)
    { top: 'text-success', mid: 'text-warning', low: 'text-danger' }[priority]
  end

  def student_count_to_course_class(count, course)
    if count.zero?
      'alert-info'
    elsif count <  course.minimum
      'alert-warning'
    elsif count >= course.minimum && count <= course.maximum
      'alert-success'
    else
      'alert-danger'
    end
  end

  def student_distribution_data(student, poll)
    course = student.courses.detect { |c| poll.courses.map(&:id).include?(c.id) }
    selection = student.selection_for(poll)

    {
      selected: false,
      course_id: course&.id,
      student_id: student.id,
      top_course_id: selection&.top_course_id,
      mid_course_id: selection&.mid_course_id,
      low_course_id: selection&.low_course_id
    }
  end
end
