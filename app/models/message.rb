class Message < ApplicationRecord
  belongs_to :user
  belongs_to :messageable, polymorphic: true

  validates :content, presence: true,
                      length: { maximum: 1000 }
end
