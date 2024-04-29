class Api::V1::ChatsController < ApplicationController
  before_action :set_chat, only: :show  
  before_action :restrict_access, only: :show

  def index
    @chats = current_user.chats
               .includes(:latest_message, :users)
               .where.not(latest_message: nil)
               .order(updated_at: :desc)
  end

  def show
    render "chat", locals: { chat: @chat }
  end

  def find_or_create
    users = [current_user, User.find(params[:user_id])]
    query = ChatBetweenUsersQuery.new(users)
    @chat = query.call || Chat.new(users: users)
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
