class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :username, presence: true, length: {maximum: 64 }
  validates :password, presence: true, length: {minimum: 6, maximum: 128 }

  has_many :user_games
  has_many :games, through: :user_games
end
