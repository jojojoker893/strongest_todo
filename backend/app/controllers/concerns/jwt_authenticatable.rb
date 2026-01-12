module JwtAuthenticatable
  extend ActiveSupport::Concern

  included do
    attr_reader :current_user
  end

  def authenticate_user
    header = request.headers["Authorization"]
    return render_unauthorized if header.nil?

    token = header.split(" ").last

    begin
      secret_key = Rails.application.credentials.secret_key_base
      decoded_token = JWT.decode(token, secret_key)

      @current_user = User.find(decoded_token[0]["user_id"])

    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render_unauthorized
    end
  end

  private

  def create_token(user_id)
    payload = { user_id: user_id, exp: 24.hours.from_now.to_i }
    secret_key = Rails.application.credentials.secret_key_base
    token = JWT.encode(payload, secret_key)
    token
  end

  def render_unauthorized
    render json: { error: "unauthorized" }, status: :unauthorized
  end
end
