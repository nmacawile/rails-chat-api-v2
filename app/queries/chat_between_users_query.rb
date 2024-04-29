class ChatBetweenUsersQuery
  def initialize(users)
    @users = users
  end

  def call
    Chat
      .joins("JOIN joins AS j1 " \
             "ON j1.joinable_type = 'Chat' " \
             "AND j1.joinable_id = chats.id")
      .joins("JOIN joins AS j2 " \
             "ON j2.joinable_type = 'Chat' " \
             "AND j2.joinable_id = chats.id")
      .where("j1.user_id <> j2.user_id")
      .where("j1.user_id = ?", users[0])
      .where("j2.user_id = ?", users[1])
      .distinct.first
  end

  private attr_reader :users
end
