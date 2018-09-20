class AddExpansionToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :expansion, :boolean
  end
end
