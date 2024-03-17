module ControllerSpecHelper
  def generate_token(user_id)
    JwtCodec.encode({ user_id: user_id })
  end

  def generate_expired_token(user_id)
    JwtCodec.encode({ user_id: user_id }, 10.seconds.ago)
  end
end
