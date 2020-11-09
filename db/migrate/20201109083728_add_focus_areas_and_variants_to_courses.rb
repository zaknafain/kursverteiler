class AddFocusAreasAndVariantsToCourses < ActiveRecord::Migration[6.0]
  def change
    change_table :courses do |table|
      table.string :focus_areas
      table.string :variants
    end
  end
end
