class AddCurrentUsersToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :current_users, :integer, default: 0
  end
end
