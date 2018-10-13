class AddMaxUsersToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :max_users, :integer
  end
end
