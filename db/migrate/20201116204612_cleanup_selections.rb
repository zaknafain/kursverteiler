class CleanupSelections < ActiveRecord::Migration[6.0]
  def change
    remove_column :selections, :priority
    remove_column :selections, :course_id
  end
end
