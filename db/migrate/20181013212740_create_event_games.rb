class CreateEventGames < ActiveRecord::Migration[5.2]
  def change
    create_table :event_games do |t|
      t.integer :event_id
      t.integer :game_id

      t.timestamps
    end
  end
end
