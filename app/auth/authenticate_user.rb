class AuthenticateUser
  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    if user&.valid_password?(password)
      return { auth_token: auth_token,
               user: user }
    end
    raise ExceptionHandler::AuthenticationError,
          "Invalid credentials."
  end

  private

  attr_reader :email, :password

  def auth_token
    JwtCodec.encode({ user_id: user.id })
  end

  def user
    @user ||= User.find_by_email(email)
  end
end
