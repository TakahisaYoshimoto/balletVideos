class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  private
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :acceptance])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :acceptance])
    end
end
