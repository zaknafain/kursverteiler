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

  def course_card_classes(selected_priority)
    classes = %w[card h-100]

    classes << 'bg-light'   if selected_priority.nil?
    classes << 'bg-success' if selected_priority == :top
    classes << 'bg-warning' if selected_priority == :mid
    classes << 'bg-danger'  if selected_priority == :low

    classes.join(' ')
  end
end
