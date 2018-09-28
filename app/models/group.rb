class Group < ApplicationRecord
  has_many :user_groups
  has_many :users, through: :user_groups

  def add_user(user_id)
    user  = User.find(user_id)
    self.users << user
  end
end
