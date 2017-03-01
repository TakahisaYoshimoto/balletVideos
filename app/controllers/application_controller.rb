class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_tags

  private
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :acceptance])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :acceptance])
    end

    def set_tags
      @tags = TopTagList.all.select(:genre, :tag_name).order('hurigana asc')
    end
end
