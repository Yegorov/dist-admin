class ProfilesController < ApplicationController
  def show
    @user = User.exist.find_by_login(params[:login])
    if @user.nil?
      render 'errors/show404' and return
    end
  end

  def edit
  end

  def update
  end
end
