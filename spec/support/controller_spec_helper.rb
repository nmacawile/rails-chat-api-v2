module ControllerSpecHelper
  def generate_token(user_id)
    JwtCodec.encode({ user_id: user_id })
  end

  def generate_expired_token(user_id)
    JwtCodec.encode({ user_id: user_id }, 10.seconds.ago)
  end

  def iso8601(time)
    Time.at(time).utc.iso8601(3)
  end

  def transform_messages(messages)
    messages.map do |m|
      {
        "id" => m.id,
        "content" => m.content,
        "created_at" => iso8601(m.created_at),
        "user" => m.user.data.transform_keys(&:to_s)
      }
    end
  end
end
