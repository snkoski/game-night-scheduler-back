class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :number_of_members
      t.string :regular_meeting_day

      t.timestamps
    end
  end
end
