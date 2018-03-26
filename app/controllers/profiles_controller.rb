class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: [:show, :edit, :update]
  before_action :allow_edit!, only: [:edit, :update]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_update_params)
      redirect_to profile_path(@user), success: "You profile update successful!"
    else
      @user.reload
      render 'edit'
    end
  end

  protected
  def find_user
    @user = User.existent.find_by_login(params[:login])
    if @user.nil?
      show404 and return
    end
  end
  def allow_edit!
    # Move to pundit gem
    unless @user.id == current_user.id
      redirect_to profile_path(@user), alert: "This action not allow!"
    end
  end
  def user_update_params
    params.require(:user).permit(:name, :public)
  end
end
