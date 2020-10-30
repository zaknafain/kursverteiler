class CreateGradesPolls < ActiveRecord::Migration[6.0]
  def change
    create_join_table :grades, :polls
    add_index :grades_polls, %i[grade_id poll_id], unique: true
  end
end
