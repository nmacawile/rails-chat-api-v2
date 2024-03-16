class JwtCodec
  HMAC_SECRET = Rails.env.production? ?
                  ENV["SECRET_KEY_BASE"] :
                  Rails.application.credentials.secret_key_base

  def self.encode(payload, exp = 1.week.from_now)
    JWT.encode({ **payload, exp: exp.to_i }, HMAC_SECRET)
  end

  def self.decode(token)
    decoded_token = JWT.decode(token, HMAC_SECRET)
    HashWithIndifferentAccess.new(decoded_token)
  end
end
