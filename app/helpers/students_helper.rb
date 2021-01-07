# frozen_string_literal: true

# Main Helper for Student related views
module StudentsHelper
  def flash_classes(flash_type)
    map = {
      error: 'danger',
      notice: 'info',
      success: 'success'
    }

    "alert alert-#{map[flash_type.to_sym]}"
  end

  def course_card_classes(selected_priority, course_disabled)
    classes = %w[card h-100]

    classes << "bg-#{priority_to_bootstrap(selected_priority)}"
    classes << 'text-muted'                             if course_disabled
    classes << "course__selected--#{selected_priority}" if selected_priority

    classes.join(' ')
  end

  def priority_button(course, priority, selected_prio, disabled)
    tag.button(
      t("students.show.prio.#{priority}"),
      type: 'button',
      disabled: disabled,
      class: priority_button_classes(priority, disabled, selected_prio == priority),
      data: priority_button_data(course, priority, selected_prio)
    )
  end

  def priority_button_classes(priority, disabled, selected)
    classes = %w[btn]

    classes << "btn-#{priority_to_bootstrap(disabled ? nil : priority)}"
    classes << "course-priority--#{priority}"
    classes << 'active border border-dark' if selected

    classes.join(' ')
  end

  def priority_button_data(course, priority, selected_prio)
    {
      course_id: course.id,
      priority: priority,
      selected_prio: selected_prio,
      guaranteed: course.guaranteed?
    }
  end

  def priority_to_bootstrap(priority)
    map = {
      nil => 'light',
      top: 'success',
      mid: 'warning',
      low: 'danger'
    }

    map[priority]
  end
end
