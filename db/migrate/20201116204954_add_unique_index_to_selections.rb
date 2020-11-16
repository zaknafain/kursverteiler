class AddUniqueIndexToSelections < ActiveRecord::Migration[6.0]
  def change
    add_index :selections, %i[poll_id student_id], unique: true
  end
end
