class RemoveDescriptionFromCourses < ActiveRecord::Migration[6.0]
  def up
    courses = Course.all.pluck(:id, :description)

    remove_column :courses, :description, :text

    courses.each do |(id, description)|
      Course.find(id).update(description: description)
    end
  end

  def down
    courses = Course.all.map { |p| [p.id, p.description.body.to_s] }

    add_column :courses, :description, :text

    courses.each do |(id, description)|
      Course.connection.execute("update courses set description = '#{description}' WHERE id = #{id}")
    end
  end
end
