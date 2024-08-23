class ChatChannel < ApplicationCable::Channel
  def subscribed
    chat = find_chat
    stream_for chat
  end

  def unsubscribed;end

  private

  def find_chat
    current_user.chats.find(params[:chat_id])
  rescue ActiveRecord::RecordNotFound
    reject
  end
end
