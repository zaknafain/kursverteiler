class AddUniqueIndexToCoursesStudents < ActiveRecord::Migration[6.0]
  def change
    add_index :courses_students, %i[course_id student_id], unique: true
  end
end
