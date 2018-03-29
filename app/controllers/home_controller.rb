class HomeController < ApplicationController
  def index
    # flash.now[:primary] = "Now is primary!"
    # flash.now[:success] = "Now is success!"
    # flash.now[:danger] = "Now is danger!"
    # flash.now[:warning] = "Now is warning!"
    # flash.now[:info] = "Now is info!"
  end
  def about
  end
  def help
  end

  def set_lang
    session[:locale] = params[:locale] || I18n.locale
  end
end
