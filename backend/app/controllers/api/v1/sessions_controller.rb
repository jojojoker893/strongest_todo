class Api::V1::SessionsController < ApplicationController
  skip_before_action :authorize_request, only: [:create]

  def create
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      token = encode_token({ user_id: user.id})

      render json: { message: "ログイン成功", token: token, user: { id: user.id, name: user.name, email: user.email } }, status: 200 
    else
      render json: { message: "メールアドレスまたは、パスワードが違います" }, status: 422
    end
  end

  def destroy
    render json: { message: "ログアウトしました" }, status: 200
  end

  private

  def encode_token(payload)
    payload[:exp] = 1.hour.from_now.to_i 
    JWT.encode(payload, Rails.application.secret_key_base)
  end
end
