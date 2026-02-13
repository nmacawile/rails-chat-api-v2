class Api::V1::ChatsController < ApplicationController
  before_action :set_chat, only: :show
  before_action :check_chat_user_presences, only: :show
  before_action :restrict_access, only: :show

  def index
    @chats = current_user.chats
               .preload(:latest_message, :users)
               .where.not(latest_message: nil)
               .order(updated_at: :desc)

    @chats.each do |chat|
      chat.users.each do |user|
        user.presence = present_user_ids.include?(user.id)
      end
    end
  end

  def show
    render_chat
  end

  def find_or_create
    users = [current_user, User.find(params[:user_id])]
    query = ChatBetweenUsersQuery.new(users)
    @chat = query.call || Chat.new(users: users)
    if (!@chat.persisted?)
      @chat.save!
      response.status = :created
    end
    @chat.users.each do |user|
      user.presence = present_user_ids.include?(user.id)
    end
    render_chat
  end

  private

  def visible_user_ids
    @visible_user_ids ||= User.where(visibility: true).pluck(:id).to_set
  end

  def present_user_ids
    @present_user_ids ||= visible_user_ids & PresenceConnection.pluck(:user_id).to_set
  end

  def set_chat
    @chat = Chat.includes(:users).find(params[:id])
  end

  def check_chat_user_presences
    @chat.users.each do |user|
      user.presence = present_user_ids.include?(user.id)
    end
  end

  def render_chat
    render "chat", locals: { chat: @chat }
  end
end
