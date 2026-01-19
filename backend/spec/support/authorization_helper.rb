module AuthorizationHelper
  def authorization_header(user)
    secret_key = Rails.application.credentials.secret_key_base

    payload = { user_id: user.id, exp: 24.hours.from_now.to_i}
    token = JWT.encode(payload, secret_key)

    { "Authorization" => "Bearer #{token}" }
  end
end
