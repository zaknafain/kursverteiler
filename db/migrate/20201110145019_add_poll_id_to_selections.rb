class AddPollIdToSelections < ActiveRecord::Migration[6.0]
  def change
    add_reference :selections, :poll, foreign_key: true
  end
end
