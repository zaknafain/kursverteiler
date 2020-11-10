class RemoveNullConstraintsFromSelections < ActiveRecord::Migration[6.0]
  def change
    change_column_null :selections, :course_id, true
    change_column_null :selections, :priority,  true
  end
end
