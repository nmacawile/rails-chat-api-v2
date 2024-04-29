class Message < ApplicationRecord
  after_create :update_messageable

  belongs_to :user
  belongs_to :messageable, polymorphic: true

  validates :content, presence: true,
                      length: { maximum: 1000 }

  private

  def update_messageable
    messageable.update(
      latest_message_id: id
    )
  end
end
