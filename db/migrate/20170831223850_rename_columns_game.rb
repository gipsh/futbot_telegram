class RenameColumnsGame < ActiveRecord::Migration[5.0]
  def change
    rename_column :games, :players, :max_players

  end
end
