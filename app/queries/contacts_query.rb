class ContactsQuery
  def initialize(user)
    @user = user
  end

  def call
    User.joins(:chats)
        .where(chats: { id: chat_ids_subquery })
        .where.not(id: user.id)
        .distinct
  end

  private

  def chat_ids_subquery
    user.chats.pluck(:id)
  end

  attr_reader :user
end
