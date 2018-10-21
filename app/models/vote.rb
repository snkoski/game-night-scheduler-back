class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :game
end
