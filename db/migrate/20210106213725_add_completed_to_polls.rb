class AddCompletedToPolls < ActiveRecord::Migration[6.1]
  def change
    add_column :polls, :completed, :datetime, precision: 6
  end
end
