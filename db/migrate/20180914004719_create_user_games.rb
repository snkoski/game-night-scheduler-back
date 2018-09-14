class CreateUserGames < ActiveRecord::Migration[5.2]
  def change
    create_table :user_games do |t|
      t.string :user_id
      t.string :game_id

      t.timestamps
    end
  end
end
