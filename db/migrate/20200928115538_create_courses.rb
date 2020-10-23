class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string  :title,   null: false
      t.integer :minimum, null: false
      t.integer :maximum, null: false
      t.text    :description
      t.string  :teacher_name
      t.boolean :mandatory, null: false, default: false

      t.timestamps null: false
    end

    add_reference :courses, :poll, foreign_key: true
  end
end
