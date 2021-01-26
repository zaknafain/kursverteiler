class AddPausedAtToStudents < ActiveRecord::Migration[6.1]
  def change
    add_column :students, :paused_at, :datetime, precision: 6, null: true
  end
end
