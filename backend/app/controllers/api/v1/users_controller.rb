class Api::V1::UsersController < ApplicationController
  before_action :authenticate, only: %i[update show destroy]

  def create
    user = User.new(user_params)
    if user.save
      render json: { message: "ユーザー登録が完了しました",user: {name: user.name, email: user.email}}, status: 201
    else
      render json: { message: user.errors.full_messages }, status: 422
    end
  end

  def destroy
    user = current_user
    if user && user.destroy
      render json: { message: "アカウントが削除されました" }, status: 200
    else
      render json: { message: "アカウントの削除に失敗しました"}, status: 422
    end
  end

  def show
    render json: { id: @current_user.id, name: @current_user.name, email: @current_user.email }, status: 200
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: { message: "ユーザー情報を更新しました", user: {name: user.name, email: user.email, password: user.password}}, status: 200
    else
      render json: { message: "ユーザー情報の更新に失敗しました"}, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
