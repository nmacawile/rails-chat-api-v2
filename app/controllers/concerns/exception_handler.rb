module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end

  included do
    rescue_from ActiveRecord::RecordInvalid,
                with: :unprocessable_response
    rescue_from ExceptionHandler::AuthenticationError,
                with: :unauthorized_response
  end

  private
  
  # 401
  def unauthorized_response(e)
    json_response({ message: e.message }, :unauthorized)
  end
  
  # 422
  def unprocessable_response(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end
end
