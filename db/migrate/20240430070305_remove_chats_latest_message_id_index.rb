class RemoveChatsLatestMessageIdIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :chats, column: :latest_message_id
  end
end
