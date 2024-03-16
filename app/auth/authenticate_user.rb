class AuthenticateUser
  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    if user 
      { auth_token: JwtCodec.encode({ user_id: user.id }),
        user: user.slice(:first_name,
                         :last_name,
                         :full_name,
                         :email) }
    end
  end

  private

  attr_reader :email, :password

  def user
    @user ||= set_user
    return @user if @user
    raise ExceptionHandler::AuthenticationError,
          "Invalid credentials."
  end

  def set_user
    _user = User.find_by_email(email)
    valid_password = _user&.valid_password?(password)
    _user if valid_password
  end  
end
