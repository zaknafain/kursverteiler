class AddNumberToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :number, :string, null: true
  end
end
