class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  protect_from_forgery prepend: true, with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(resource_or_scope)
    dashboard_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fullname])
    devise_parameter_sanitizer.permit(:account_update, keys: [:fullname, :phone_number, :description, :password, :password_confirmation])

  end
end


# devise gem doc - there are 2 places (forms to update)
# update parameters for phone and description
# ActionController::InvalidAuthenticityToken in RegistrationsController#create
# --> updated above link for protection in Rails 5.2
# ====================================================
# new controller for showing user's dashboard when sign-in redirect there
