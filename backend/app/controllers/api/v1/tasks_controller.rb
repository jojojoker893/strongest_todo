class Api::V1::TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:update, :destroy]

  def index
    @tasks = Task.order(created_at: :desc).page(params[:page]).per(10)

    pagination = {
      current: @tasks.current_page,
      next: @tasks.next_page,
      prev: @tasks.prev_page,
      total_pages: @tasks.total_pages,
      count_pages: @tasks.total_count
    }

    render json: { tasks: @tasks, meta: pagination }, status: :ok
  end

  def create
    task = current_user.tasks.build(task_params)

    if task.save
      render json: { message: "タスクを登録しました", task: task }, status: :created
    else
      render json: { message: "タスクの登録に失敗しました", errors: task.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    if @task.destroy
      render json: { message: "タスクを削除しました" }, status: :ok
    else
      render json: { message: "タスクの削除に失敗しました" }, status: :unprocessable_content
    end
  end

  def update
    if @task.update(task_params)
      render json: { message: "タスクを更新しました" }, status: :ok
    else
      render json: { message: "タスクの更新に失敗しました", errors: @task.errors.full_messages }, status: :unprocessable_content
    end
  end

  private

  def set_task
    @task = current_user.tasks.find_by(id: params[:id])

    if @task.nil?
      render json: { message: "タスクがありません" }, status: :not_found
    end
  end

  def task_params
    params.require(:task).permit(:title, :description, :category, :status, :visibility)
  end
end
