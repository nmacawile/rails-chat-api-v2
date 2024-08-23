class Api::V1::MessagesController < ApplicationController
  before_action :load_messageable, only: [:index, :create]
  before_action :restrict_access, only: [:index, :create]

  def index
    @messages = @chat.messages.page
    if (params[:before])
      @messages = @messages.older_than(params[:before])
    end
  end

  def create
    message = @chat.messages.build(message_params)
    message.user = current_user
    message.save!
    ChatChannel.broadcast_to @chat, chat_message: render(message)
    head :no_content
  end
  
  private

  def message_params
    params.require(:message).permit(:content)
  end

  def load_messageable
    @chat = Chat.find(params[:chat_id])
  end
end
