class Message < ApplicationRecord
  default_scope { order(created_at: :desc) }

  scope :older_than, ->(id) do
    timestamp_subquery = select(:created_at).where(id: id).to_sql
    where("messages.created_at < (#{timestamp_subquery})")
  end

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
