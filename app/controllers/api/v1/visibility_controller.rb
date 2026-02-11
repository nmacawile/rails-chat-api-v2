class Api::V1::VisibilityController < ApplicationController
  before_action :set_visibility_values

  def update
    if @old_value != @new_value
      current_user.update!(visibility: @new_value, last_seen: Time.current)
      broadcast_presence_update
    end
    json_response(user: current_user.complete_data)
  end

  private

  def set_visibility_values
    @old_value = current_user.visibility
    @new_value = ActiveModel::Type::Boolean.new.cast(params[:visibility])
  end

  def broadcast_presence_update
    presence = PresenceConnection.exists?(user_id: current_user.id)

    ActionCable.server.broadcast("presence", { 
                                               id: current_user.id,
                                               last_seen: current_user.last_seen,
                                               presence: presence && @new_value
                                             })
  end
end
