class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.references :game, foreign_key: true
      t.string :player_name
      t.string :player_external_id

      t.timestamps
    end
  end
end
