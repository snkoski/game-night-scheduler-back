class AddBggIdToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :bgg_id, :string
  end
end
