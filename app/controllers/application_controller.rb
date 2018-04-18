class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper
  before_action :set_locale, except: :set_lang
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  # rescue_from Exception do |exception|
  #   redirect_to main_app.root_path, alert: exception.message
  # end

  rescue_from Pundit::NotAuthorizedError do |e|
    flash[:alert] = "Sorry, but You are not authorized to perform this action."
    #redirect_to(request.referrer || root_path) # root_path raise exception
    redirect_to request.referrer || "/"
  end

  def set_lang
    if I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale].to_sym
      I18n.locale = session[:locale].to_sym
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :login])
  end
  def after_sign_in_path_for(resource)
    profile_path(resource)
  end
  def set_locale
    #binding.pry
    # Locale sets in rack middleware
    #I18n.locale = :ru
    if session[:locale].present?
      if I18n.available_locales.include?(session[:locale].to_sym)
        I18n.locale = session[:locale].to_sym
      end
    end

    if params[:locale].present?
      locale = params[:locale].to_sym
      if I18n.available_locales.include?(locale)
        I18n.locale = locale
      end
    end

    logger.warn "Locale: #{I18n.locale}"
  end

end
