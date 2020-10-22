class CreateEducationalPrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :educational_programs do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :educational_programs, :name, unique: true
  end
end
