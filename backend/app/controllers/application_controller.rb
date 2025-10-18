class ApplicationController < ActionController::API
  before_action :authorize_request

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    
    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
      @current_user = User.find(decoded["user_id"])
    rescue JWT::DecodeError, ActiveRecord::Record::RecordNotFound
      render json: { message: "認証に失敗しました" }, status: 401
    end
  end
end
