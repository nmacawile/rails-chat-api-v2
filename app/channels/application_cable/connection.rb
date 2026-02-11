module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :connection_id

    def connect
      self.current_user = find_verified_user
      self.connection_id = SecureRandom.uuid
    end

    private

    def find_verified_user
      (AuthorizeApiRequest.new(request.params).call)[:user]
    rescue
      reject_unauthorized_connection
    end
  end
end
