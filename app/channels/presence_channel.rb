class PresenceChannel < ApplicationCable::Channel 
  def subscribed
    stream_from "presence"
    update_presence(true)
  end

  def unsubscribed
    update_presence(false)
  end

  private
  
  def update_presence(presence)
    current_user.update!(presence: presence)
    ActionCable.server.broadcast("presence", {
                      id: current_user.id,
                      presence: presence,
                      last_seen: current_user.last_seen })
  end
end
