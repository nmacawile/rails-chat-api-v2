class AddLatestMessageToChats < ActiveRecord::Migration[7.1]
  def change
    add_column :chats, :latest_message_id, :integer
    add_index :chats, :latest_message_id

    # set a value for existing records
    Chat.find_each do |chat|
      # find latest message by chat
      latest_message = chat.messages
        .order(created_at: :desc)
        .select(:id, :created_at).first

      if latest_message
        # update columns
        chat.update_columns(
          latest_message_id: latest_message.id,
          updated_at: latest_message.created_at
        )
      end
    end
  end
end
