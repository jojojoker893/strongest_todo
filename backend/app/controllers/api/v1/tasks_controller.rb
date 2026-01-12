class Api::V1::TasksController < ApplicationController
  def index
    tasks = @current_user.tasks

    if tasks.empty?
      render json: { message: "タスクがありません" }, status: 400
    else
      render json: { tasks: tasks }, status: 200
    end
  end

  def create
    task = Task.new(task_params)

    if task.save
      render json: { message: "タスクを登録しました" }, status: 200
    else
      render json: { message: "タスクの登録に失敗しました" }, status: 422
    end
  end

  def destory
    task = current_user.tasks.find_by(id: params[:id])

    if task.nil?
      render json: { message: "タスクがありません" }, status: 404
    elsif task.destory
      render json: { message: "タスクを削除しました" }, status: 200
    else
      render json: { message: "タスクの削除に失敗しました" }, status: 422
    end
  end

  def update
    if task.update(task_params)
      render json: { message: "タスクを更新しました" }, status: 200
    else
      render json: { message: "タスクの更新に失敗しまsた" }, status: 422
    end
  end

  def show
    task = @cureent_user.tasks.find_by(id: task_params[:id])

    if task
      render json: task, status: 200
    else
      render json: { message: "タスクがありません" }, status: 404
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :category, :user_id, :created_at)
  end
end
