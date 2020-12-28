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
end
