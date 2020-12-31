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

    classes << 'bg-light'                               if selected_priority.nil?
    classes << 'bg-success'                             if selected_priority == :top
    classes << 'bg-warning'                             if selected_priority == :mid
    classes << 'bg-danger'                              if selected_priority == :low
    classes << 'text-muted'                             if course_disabled
    classes << "course__selected--#{selected_priority}" if selected_priority

    classes.join(' ')
  end

  def priority_button(course, priority, selected_prio, disabled)
    tag.button(
      t("students.show.prio.#{priority}"),
      type: 'button',
      disabled: disabled,
      class: priority_button_classes(priority, disabled),
      data: priority_button_data(course, priority, selected_prio)
    )
  end

  def priority_button_classes(priority, disabled)
    classes = %w[btn]

    if disabled
      classes << 'btn-light'
    else
      classes << 'btn-success' if priority == :top
      classes << 'btn-warning' if priority == :mid
      classes << 'btn-danger'  if priority == :low
    end
    classes << "course-priority--#{priority}"

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
end
