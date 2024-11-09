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
      NotificationsChannel.broadcast_to current_user, chat_message: {
        id: @message.id,
        content: @message.content[0,50],
        user: @message.user.data,
        created_at: @message.created_at
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
