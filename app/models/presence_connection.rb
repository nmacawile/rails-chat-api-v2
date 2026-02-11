class PresenceConnection < ApplicationRecord
  belongs_to :user

  validates :connection_id, presence: true
  validates :last_seen, presence: true
end
