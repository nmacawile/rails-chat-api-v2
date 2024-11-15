class Api::V1::MessagesController < ApplicationController
  before_action :load_messageable, only: [:index, :create]
  before_action :restrict_access, only: [:index, :create]
  after_action :notify_users, only: :create
  after_action :broadcast_message, only: :create

  def index
    @messages = @chat.messages.page
    if (params[:before])
      @messages = @messages.older_than(params[:before])
    end
  end

  def create
    @message = @chat.messages.build(message_params)
    @message.user = current_user
    @message.save!
    head :no_content
  end
  
  private

  def message_params
    params.require(:message).permit(:content)
  end

  def load_messageable
    @chat = Chat.find(params[:chat_id])
  end

  def notify_users
    @chat.users.each do |user|
      NotificationsChannel.broadcast_to user, chat: {
          id: @chat.id,
          type: "Chat",
          users: @chat.users.map { |u| u.data },
          latest_message: {
            content: @chat.latest_message.content,
            user: @chat.latest_message.user.data
          }    
        }
    end
  end

  def broadcast_message
    ChatChannel.broadcast_to @chat, chat_message: {
      id: @message.id,
      content: @message.content,
      user: @message.user.data,
      created_at: @message.created_at
    }                                            
  end
end
