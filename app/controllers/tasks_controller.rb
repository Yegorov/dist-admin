class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_task, only: [:show, :start, :restart, :stop]

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
    if not @task.can_start?
      Log.create(message: "Task: #{task.inspect!} can not started",
                 status: "warn",
                 subject: "TasksController::start")
      redirect_to task_path(@task), alert: "Task can not be started"
    else
      TaskManager.delay(:queue => 'task')
                 .start(@task.id, current_user.id)
      @task.start
      redirect_to task_path(@task), notice: "Task be started ..."
    end
  end
  def restart
    if not @task.can_restart?
      Log.create(message: "Task: #{task.inspect!} can not restarted",
                 status: "warn",
                 subject: "TasksController::restart")
      redirect_to task_path(@task), alert: "Task can not be restarted ..."
    else
      TaskManager.delay(:queue => 'task')
                 .restart(@task.id, current_user.id)
      @task.restart
      redirect_to task_path(@task), notice: "Task be restarted ..."
    end
  end
  def stop
    if not @task.can_stop?
      Log.create(message: "Task: #{task.inspect!} can not stopped",
                 status: "warn",
                 subject: "TasksController::stop")
      redirect_to task_path(@task), alert: "Task can not be stopped ..."
    else
      # need priority queue for stop task
      # TaskManager.delay(:queue => 'task_stop')
      #            .stop(@task.id, current_user.id)
      # @task.stop
      @task.stop
      TaskManager.stop(@task.id, current_user.id)
      redirect_to task_path(@task), notice: "Task be stopped ..."
    end
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
