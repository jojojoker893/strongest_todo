class Api::V1::TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:update, :destroy]

  def index
    tasks = current_user.tasks
    render json: { tasks: tasks }, status: :ok
  end

  def create
    task = current_user.tasks.build(task_params)

    if task.save
      render json: { message: "タスクを登録しました", task: task }, status: :created
    else
      render json: { message: "タスクの登録に失敗しました", errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    task = current_user.tasks.find_by(id: params[:id])

    if task.destroy
      render json: { message: "タスクを削除しました" }, status: 200
    else
      render json: { message: "タスクの削除に失敗しました" }, status: 422
    end
  end

  def update
    task = Task.find_by(id: params[:id])

    if task.update(task_params)
      render json: { message: "タスクを更新しました" }, status: :ok
    else
      render json: { message: "タスクの更新に失敗しました", errors: task.errors.full_messages }, status: :unprocessable_content
    end
  end

  private

  def set_task
    render json: { message: "タスクがありません" }, status: :not_found if task.nil?
  end

  def task_params
    params.require(:task).permit(:title, :description, :category, :status, :visibility)
  end
end
