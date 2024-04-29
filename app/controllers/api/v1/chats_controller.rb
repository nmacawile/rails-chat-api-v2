class Api::V1::ChatsController < ApplicationController
  before_action :set_chat, only: :show  
  before_action :restrict_access, only: :show

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
    render "chat", locals: { chat: @chat }
  end

  def find_or_create
    user = User.find(params[:user_id])
    @chat = Chat
      .joins("JOIN joins AS j1 " \
             "ON j1.joinable_type = 'Chat' " \
             "AND j1.joinable_id = chats.id")
      .joins("JOIN joins AS j2 " \
             "ON j2.joinable_type = 'Chat' " \
             "AND j2.joinable_id = chats.id")
      .where("j1.user_id <> j2.user_id")
      .where("j1.user_id = ?", current_user)
      .where("j2.user_id = ?", user)
      .distinct.first || Chat.new(users: [current_user, user])
    if (!@chat.persisted?)
      @chat.save!
      response.status = :created
    end
    render "chat", locals: { chat: @chat }
  end

  private

  def set_chat
    @chat = Chat.includes(:users).find(params[:id])
  end
  
  def restrict_access
    unless @chat.users.include?(current_user)
      raise ExceptionHandler::Forbidden, "Access denied"
    end
  end
end
