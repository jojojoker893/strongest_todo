class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = create_token(user.id)

      render json: { message: "ログイン成功", token: token, user: { id: user.id, name: user.name, email: user.email } }, status: 200
    else
      render json: { message: "メールアドレスまたは、パスワードが違います" }, status: 422
    end
  end

  def destroy
    render json: { message: "ログアウトしました" }, status: 200
  end
end
