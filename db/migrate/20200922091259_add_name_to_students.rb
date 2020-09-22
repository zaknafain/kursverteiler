class AddNameToStudents < ActiveRecord::Migration[6.0]
  def change
    add_column :students, :first_name, :string, null: false
    add_column :students, :last_name, :string, null: false
  end
end
