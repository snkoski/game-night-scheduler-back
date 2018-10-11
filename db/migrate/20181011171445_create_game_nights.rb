class CreateGameNights < ActiveRecord::Migration[5.2]
  def change
    create_table :game_nights do |t|
      t.string :name
      t.date :date
      t.time :time

      t.timestamps
    end
  end
end
