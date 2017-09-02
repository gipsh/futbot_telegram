class RenameColumnsPlayer < ActiveRecord::Migration[5.0]
  def change
    rename_column :players, :player_name, :name
    rename_column :players, :player_external_id, :external_id
    add_column :players, :added_by, :string
  end
end
