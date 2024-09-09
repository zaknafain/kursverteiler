class AddCoordinatorsToAdmins < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :coordinator, :boolean, default: false, null: false
  end
end
