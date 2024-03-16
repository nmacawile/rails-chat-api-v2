module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end

  included do
    rescue_from ExceptionHandler::AuthenticationError,
                with: :unauthorized_response
  end

  private

  def unauthorized_response(e)
    json_response({ message: e.message }, :unauthorized)
  end
end
