class AuthorizeApiRequest
  def initialize(headers)
    @headers = headers
  end

  def call
    { user: user.data }
  end

  private

  attr_accessor :headers

  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
  rescue ActiveRecord::RecordNotFound => e
    raise ExceptionHandler::InvalidToken, "Invalid token: #{e.message}"
  end

  def decoded_auth_token
    @decoded_auth_token ||= JwtCodec.decode(http_auth_token)
  end

  def http_auth_token
    if headers["Authorization"].present?
      return headers["Authorization"].split(" ").last
    end
    raise ExceptionHandler::MissingToken, "Missing token."
  end
end
