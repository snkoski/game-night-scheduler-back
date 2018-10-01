class CreateNights < ActiveRecord::Migration[5.2]
  def change
    create_table :nights do |t|
      t.date :date
      t.time :time
      t.integer :number_of_members

      t.timestamps
    end
  end
end
