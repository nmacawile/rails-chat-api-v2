class AuthorizeApiRequest
  def initialize(headers)
    @headers = headers
  end

  def call
    user_id = JwtCodec.decode(http_auth_token)["user_id"]
    user = User.find(user_id)
    { user: user.data }
  end

  private

  attr_accessor :headers

  def http_auth_token
    if headers["Authorization"].present?
      return headers["Authorization"].split(" ").last
    end
  end
end
