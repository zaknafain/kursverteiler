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
    selection = student.selection_for(poll)
    courses = poll.courses

    {
      student_id: student.id,
      toggle: 'popover',
      placement: 'right',
      content: "
        #{student.official_name} (#{student.grade.name})
        <br><br>
        #{selection_to_html(selection, courses)}
        #{old_courses_to_html(student, courses)}
      "
    }
  end

  def selection_to_html(selection, courses)
    %i[top mid low].each_with_object([]) do |prio, array|
      array << if selection&.send("#{prio}_course_id").nil?
                 "#{send("#{prio}_translation")}: ---"
               else
                 "#{send("#{prio}_translation")}: #{selection_title(selection&.send("#{prio}_course_id"), courses)}"
               end
    end.join('<br>')
  end

  def old_courses_to_html(student, courses)
    old_courses = courses.select { |c| c.parent_course_id && student.courses.map(&:id).include?(c.parent_course_id) }

    return '' if old_courses.empty?

    old_courses.map! { |c| "<i class='icon-warning-sign'></i> #{c.title}" }
    "<br><br>#{old_courses.join('<br>')}"
  end

  def selection_title(course_id, courses)
    courses.detect { |c| c.id == course_id }&.title
  end

  def top_translation
    @top_translation ||= t('students.show.prio.top')
  end

  def mid_translation
    @mid_translation ||= t('students.show.prio.mid')
  end

  def low_translation
    @low_translation ||= t('students.show.prio.low')
  end
end
