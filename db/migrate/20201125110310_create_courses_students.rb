class CreateCoursesStudents < ActiveRecord::Migration[6.0]
  def change
    create_join_table :courses, :students
  end
end
