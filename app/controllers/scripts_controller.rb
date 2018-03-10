class ScriptsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_script, only: [:show, :edit]

  def index
    @scripts = Script.order(updated_at: :desc)
                     .owned(current_user)
                     .page(params[:page])
  end

  def show
  end

  def new
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def find_script
    @script = Script.owned(current_user).find(params[:id])
  end
end
