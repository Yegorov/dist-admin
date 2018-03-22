class Task::LogsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_task, only: [:index, :show]

  def index
    @logs = TaskLog.by_task(@task)
                   .order(created_at: :desc)
                   .page(params[:page])
  end

  def show
    @log = TaskLog.by_task(@task)
                  .find(params[:id])
  rescue
    show404
  end

  private
  def find_task
    @task = Task.owned(current_user).find(params[:task_id])
  rescue
    show404
  end
end
