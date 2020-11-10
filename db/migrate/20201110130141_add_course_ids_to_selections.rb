class AddCourseIdsToSelections < ActiveRecord::Migration[6.0]
  def change
    add_reference :selections, :top_course, foreign_key: { to_table: :courses }
    add_reference :selections, :mid_course, foreign_key: { to_table: :courses }
    add_reference :selections, :low_course, foreign_key: { to_table: :courses }
  end
end
