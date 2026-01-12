class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, only: %i[update destroy index]

  def index
    render json: current_user.as_json(except: :password_digest)
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: { message: "Created", user: { name: user.name, email: user.email } }, status: :created
    else
      render json: { message: user.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    user = current_user
    if user && user.destroy
      render json: { message: "Deleted" }, status: :ok
    else
      render json: { message: user.errors.full_messages }, status: :unprocessable_content
    end
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: { message: "Updated", user: { name: user.name, email: user.email, password: user.password } }, status: :ok
    else
      render json: { message: user.errors.full_messages }, status: :unprocessable_content
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
