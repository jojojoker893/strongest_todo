class JwtAuth
  def self.call(token)
    return nil if token.blank?

    begin
      secret_key = Rails.application.credentials.secret_key_base
      decoded_token = JWT.decode(token, secret_key)
      user_id = decoded_token[0]["user_id"]

      User.find(user_id)
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end
  end

end
