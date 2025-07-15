class Api::V1::VisibilityController < ApplicationController
  before_action :set_visibility
  after_action :broadcast_presence, only: :update

  def update
    current_user.update!(visibility: @visibility,
                         presence: @visibility)
    json_response(user: current_user.complete_data)
  end

  private

  def set_visibility
    @visibility = params[:visibility]
  end

  def broadcast_presence
    ActionCable.server.broadcast("presence",
                                   current_user.slice(:id,
                                                      :last_seen,
                                                      :presence))
  end
end
