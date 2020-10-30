class CreateGrades < ActiveRecord::Migration[6.0]
  def change
    create_table :grades do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :grades, :name, unique: true
    add_reference :students, :grade, foreign_key: true
  end
end
