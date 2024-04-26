class Api::V1::ChatsController < ApplicationController
  def index
    user_chat_ids = current_user.chats.select(:id)
    # query latest message time by distinct chats, latest first
    latest_message_times_by_distinct_chats_subquery = Message
      .select("messageable_id, MAX(created_at) AS latest_message_time")
      .where(messageable_id: user_chat_ids)
      .order("latest_message_time DESC")
      .group(:messageable_id).to_sql

    # query latest chat messages, eager load chat and chat users
    @latest_chat_messages_with_inclusions = Message
        .joins("JOIN (#{latest_message_times_by_distinct_chats_subquery}) AS latest_message_times " \
              "ON messages.messageable_id = latest_message_times.messageable_id " \
              "AND messages.created_at = latest_message_times.latest_message_time")
        .includes(messageable: :users)
  end

  def show
    @chat = Chat.includes(:users).find(params[:id])
  end
end
