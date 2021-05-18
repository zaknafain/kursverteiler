class SetValidUntilOnGrades < ActiveRecord::Migration[6.1]
  def up
    Grade.all.each do |grade|
      grade.update(valid_until: grade.created_at + 3.years)
    end
  end

  def down
    Grade.all.each do |grade|
      grade.update(valid_until: nil)
    end
  end
end
