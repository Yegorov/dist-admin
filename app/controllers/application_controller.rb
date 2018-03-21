class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper
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

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :login])
  end
  def after_sign_in_path_for(resource)
    profile_path(resource)
  end
end
