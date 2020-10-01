class CreateSelections < ActiveRecord::Migration[6.0]
  def change
    create_table :selections do |t|
      t.belongs_to :student,  index: true, foreign_key: true, null: false
      t.belongs_to :poll,     index: true, foreign_key: true, null: false
      t.belongs_to :course,   index: true, foreign_key: true, null: false
      t.integer    :priority, null: false, default: 0

      t.timestamps
    end

    add_index :selections, [:student_id, :poll_id, :priority], unique: true
  end
end
