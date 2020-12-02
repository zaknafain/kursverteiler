# frozen_string_literal: true

# Main Helper for Student related views
module StudentsHelper
  def course_classes(prio_selected, disabled)
    classes = ['course']

    classes << 'course__selected'                   if prio_selected.present?
    classes << "course__selected--#{prio_selected}" if prio_selected.present?
    classes << 'course__disabled'                   if disabled

    classes.join(' ')
  end

  def course_prio_classes(priority, selected, guaranteed, disabled)
    classes = ['course-priority--container']

    classes << "course-priority--container__#{priority}"
    classes << 'course-priority--container__selected' if selected
    classes << 'course-priority--container__disabled' if disabled || guaranteed && %i[mid low].include?(priority)

    classes.join(' ')
  end
end
