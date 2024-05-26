class AuthenticateUser
  def initialize(email, password)
    @email = email
    @password = password
    @exp = 1.week.from_now
  end

  def call
    if user&.valid_password?(password)
      return { auth_token: auth_token,
               user: user,
               exp: exp.to_i }
    end
    raise ExceptionHandler::AuthenticationError,
          "Invalid credentials."
  end

  private

  attr_reader :email, :password, :exp

  def auth_token
    JwtCodec.encode({ user_id: user.id }, exp)
  end

  def user
    @user ||= User.find_by_email(email)
  end
end
