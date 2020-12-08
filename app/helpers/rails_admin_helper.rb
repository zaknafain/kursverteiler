# frozen_string_literal: true

# Main Helper for RailsAdmin related views
module RailsAdminHelper
  def classes_for(course)
    classes = %w[course]

    classes << if course.guaranteed?
                 'course__guaranteed'
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
    student.selection_for(poll)&.send("#{priority}_course_id").present? ? "#{priority}-indicator" : 'missing-indicator'
  end

  def student_count_to_course_class(count, course)
    if count.zero?
      'course__empty'
    elsif count <  course.minimum
      'course__too-low'
    elsif count >= course.minimum && count <= course.maximum
      'course__good'
    else
      'course__too-many'
    end
  end

  def student_distribution_data(student, courses)
    course = student.courses.detect { |c| courses.map(&:id).include?(c.id) }

    {
      selected: false,
      course_id: course&.id,
      student_id: student.id
    }
  end
end
