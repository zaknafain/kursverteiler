# frozen_string_literal: true

# Main Helper for Student related views
module StudentsHelper
  def course_card_classes(selected_priority, course_disabled)
    classes = %w[divide-y divide-gray-200 overflow-hidden rounded-lg bg-white shadow-sm mb-4]

    classes << 'text-gray-500'                 if course_disabled
    classes << "selected #{selected_priority}" if selected_priority

    classes.join(' ')
  end

  def priority_button(course, priority, selected_prio)
    tag.button(
      type: 'button',
      class: priority_button_classes(priority),
      data: priority_button_data(course, priority)
    ) do
      priority_button_content(priority, selected_prio == priority)
    end
  end

  def priority_button_content(priority, selected)
    safe_join(
      [
        tag.div(t("students.show.prio.#{priority}")),
        check_icon(selected)
      ]
    )
  end

  def check_icon(selected)
    tag.svg(class: "#{'hidden' unless selected} -ml-0.5 size-5", viewBox: '0 0 20 20', fill: 'currentColor',
            'aria-hidden': 'true', 'data-slot': 'icon') do
      tag.path('fill-rule': 'evenodd', 'clip-rule': 'evenodd',
               d: 'M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm3.857-9.809a.75.75 0 0 0-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 1 0-1.06 1.061l2.5 2.5a.75.75 0 0 0 1.137-.089l4-5.5Z') # rubocop:disable Layout/LineLength
    end
  end

  def priority_button_classes(priority)
    classes = %w[inline-flex justify-center gap-x-1.5 rounded-sm rounded-sm px-2 py-1 text-sm font-semibold shadow-xs]

    classes << priority_color_button(priority)

    classes.join(' ')
  end

  def priority_button_data(course, priority)
    {
      selection_form_course_id_param: course.id,
      selection_form_course_prio_param: priority,
      action: 'click->selection-form#toggle'
    }
  end

  def priority_color_button(priority)
    map = {
      top: 'bg-emerald-50 text-emerald-600 hover:bg-emerald-100',
      mid: 'bg-amber-50 text-amber-600 hover:bg-amber-100',
      low: 'bg-rose-50 text-rose-600 hover:bg-rose-100'
    }

    map[priority]
  end
end
