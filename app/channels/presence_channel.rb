class PresenceChannel < ApplicationCable::Channel 
  def subscribed
    stream_from "presence"
    add_presence

    if (!has_other_connections? && current_user.visibility)
      ActionCable.server.broadcast(
        "presence", { 
          id: current_user.id,
          last_seen: current_user.last_seen,
          presence: true
        }
      )
    end
  end

  def unsubscribed
    delete_presence

    if (!has_other_connections?)
      ActionCable.server.broadcast(
        "presence", { 
          id: current_user.id,
          last_seen: current_user.last_seen,
          presence: false
        }
      )
    end
  end

  private

  def has_other_connections?
    PresenceConnection
      .where(user_id: current_user.id)
      .where.not(connection_id: connection.connection_id)
      .exists?
  end

  def add_presence
    current_time = Time.current
 
    PresenceConnection.upsert({
        user_id: current_user.id,
        connection_id: connection.connection_id,
        last_seen: current_time,
        created_at: current_time,
        updated_at: current_time
      },
      unique_by: %i[user_id connection_id]
    )
  end

  def delete_presence
    PresenceConnection.where(
      user_id: current_user.id,
      connection_id: connection.connection_id
    ).delete_all
  end
end
