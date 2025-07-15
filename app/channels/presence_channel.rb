class PresenceChannel < ApplicationCable::Channel 
  def subscribed
    stream_from "presence"
    update_presence(true) if current_user.visibility
  end

  def unsubscribed
    update_presence(false)
  end

  private
  
  def update_presence(presence)
    current_user.update!(presence: presence)
    ActionCable.server.broadcast(
                        "presence",
                         current_user.slice(:id, :last_seen, :presence))
  end
end
