class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_task, only: [:show, :start, :stop]

  def index
    @tasks = Task.order(updated_at: :desc)
                 .owned(current_user)
                 .page(params[:page])
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
  end

  # def edit
  #   raise "not present"
  # end

  # def update
  #  raise "not present"
  # end

  # def destroy
  # end

  def start

    redirect_to task_path(@task), alert: "Task be started ..."
  end
  def stop

    redirect_to task_path(@task), alert: "Task be stopped ..."
  end

  private
  def find_task
    @task = Task.owned(current_user).find(params[:id])
  rescue
    show404
  end
end
