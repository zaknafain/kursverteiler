class CreatePolls < ActiveRecord::Migration[6.0]
  def change
    create_table :polls do |t|
      t.string :title,       null: false
      t.date   :valid_from,  null: false
      t.date   :valid_until, null: false

      t.timestamps null: false
    end

    add_reference :polls, :educational_program, foreign_key: true
  end
end
