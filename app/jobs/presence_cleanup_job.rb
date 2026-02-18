class PresenceCleanupJob < ApplicationJob
  queue_as :default

  def perform
    expired_presences.delete_all
    broadcast_disconnections
  end

  private 

  def broadcast_disconnections
    return unless disconnected_user_ids.any?
    disconnected_user_ids.each do |user_id|
      ActionCable.server.broadcast(
        "presence", {
          id: user_id,
          last_seen: Time.current,
          presence: false
        }
      )
    end
  end

  def cutoff_time
    90.seconds.ago
  end

  def expired_presences
    @expired_presences ||= PresenceConnection
                            .where('last_seen < ?', cutoff_time)
  end

  def affected_user_ids
    @affected_user_ids ||= expired_presences.pluck(:user_id).uniq
  end

  def still_connected_user_ids
    @still_connected_user_ids ||= PresenceConnection
                                  .where(user_id: affected_user_ids)
                                  .pluck(:user_id)
  end

  def disconnected_user_ids
    @disconnected_user_ids ||= affected_user_ids - still_connected_user_ids
  end
end  