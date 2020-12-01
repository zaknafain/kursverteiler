class AddParentCourseIdToCourses < ActiveRecord::Migration[6.0]
  def change
    add_reference :courses, :parent_course, foreign_key: { to_table: :courses }, null: true
  end
end
