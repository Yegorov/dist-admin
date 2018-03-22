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
    load_scripts
  end

  def create
    @task = Task.new(task_params)
    @task.owner = current_user
    if @task.save
      redirect_to task_path(@task)
    else
      load_scripts
      render 'new'
    end
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
  def restart

    redirect_to task_path(@task), alert: "Task be restarted ..."
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
  def task_params
    params.require(:task).permit(:name, :script_id)
  end
  def load_scripts
    @scripts = Script.order(updated_at: :desc)
                 .owned(current_user)
                 .limit(100)
                 .pluck(:name, :id)
  end
end
