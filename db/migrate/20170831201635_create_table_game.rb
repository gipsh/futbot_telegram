class CreateTableGame < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.datetime :due_date
      t.datetime :next_game
      t.integer :players
      t.string :group_id
      t.boolean :recurrent
      
    end
  end
end
