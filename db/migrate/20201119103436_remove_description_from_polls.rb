class RemoveDescriptionFromPolls < ActiveRecord::Migration[6.0]
  def up
    polls = Poll.all.pluck(:id, :description)

    remove_column :polls, :description, :text

    polls.each do |(id, description)|
      Poll.find(id).update(description: description)
    end
  end

  def down
    polls = Poll.all.map { |p| [p.id, p.description.body.to_s] }

    add_column :polls, :description, :text

    polls.each do |(id, description)|
      Poll.connection.execute("update polls set description = '#{description}' WHERE id = #{id}")
    end
  end
end
