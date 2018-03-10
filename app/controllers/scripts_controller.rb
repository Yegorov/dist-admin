class ScriptsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_script, only: [:show, :edit, :update, :destroy]

  def index
    @scripts = Script.order(updated_at: :desc)
                     .owned(current_user)
                     .page(params[:page])
  end

  def show
  end

  def new
    @script = Script.new
  end

  def create
    @script = Script.new(script_params)
    @script.owner = current_user
    if @script.save
      redirect_to script_url(@script, login: current_user)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @script.update(script_params)
      redirect_to script_url(@script, login: current_user)
    else
      render 'edit'
    end
  end

  def destroy
    @script.destroy
    redirect_to scripts_url(login: current_user)
  end

  private
  def find_script
    @script = Script.owned(current_user).find(params[:id])
  rescue
    show404
  end
  def script_params
    params.require(:script).permit(:name, :description, :mapper, :reducer,
                                   :input, :output, :language)
  end
end
