class AddColumnOwnerToGame < ActiveRecord::Migration[5.0]
  def change
	add_column :games, :owner_id, :string
	add_column :games, :owner_name, :string
  end
end
