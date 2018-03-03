class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
  end

  protected
  def find_user
    @user = User.exist.find_by_login(params[:login])
    if @user.nil?
      show404 and return
    end
  end
end
