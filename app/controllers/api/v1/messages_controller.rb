class Api::V1::MessagesController < ApplicationController
  before_action :load_messageable, only: :index
  before_action :restrict_access, only: :index

  def index
    @messages = @chat.messages.page
    if (params[:before])
      @messages = @messages.older_than(params[:before])
    end
  end
  
  private

  def load_messageable
    @chat = Chat.find(params[:chat_id])
  end
end
