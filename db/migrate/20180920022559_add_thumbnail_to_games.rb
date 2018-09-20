class AddThumbnailToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :thumbnail, :string
  end
end
