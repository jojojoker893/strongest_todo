class JwtToken
  def self.call(user)
    payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
    secret_key = Rails.application.credentials.secret_key_base
    token = JWT.encode(payload, secret_key)
    token
  end
  
end