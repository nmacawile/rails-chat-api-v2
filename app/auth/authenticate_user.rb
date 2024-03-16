class AuthenticateUser
  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    if user&.valid_password?(password)
      return { auth_token: JwtCodec.encode({ user_id: user.id }),
               user: user.slice(:first_name,
                                :last_name,
                                :full_name,
                                :email) }
    end
    raise ExceptionHandler::AuthenticationError,
          "Invalid credentials."
  end

  private

  attr_reader :email, :password

  def user
    @user ||= User.find_by_email(email)
  end
end
