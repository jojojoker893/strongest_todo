class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JwtToken.call(user.id)

      render json: { message: "ログイン成功", token: token, user: { id: user.id, name: user.name, email: user.email } }, status: :ok
    else
      render json: { message: "メールアドレスまたは、パスワードが違います" }, status: :unprocessable_content
    end
  end

  def destroy
    render json: { message: "ログアウトしました" }, status: :ok
  end
end
