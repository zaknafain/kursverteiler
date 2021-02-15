class AddValidUntilToGrades < ActiveRecord::Migration[6.1]
  def change
    add_column :grades, :valid_until, :date, null: true, default: nil
  end
end
