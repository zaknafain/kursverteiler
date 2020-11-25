class RemoveNullConstraintFromCourses < ActiveRecord::Migration[6.0]
  def change
    change_column_null :courses, :minimum, true
    change_column_null :courses, :maximum, true
  end
end
