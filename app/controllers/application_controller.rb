class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_tags

  def user_level_check(level)
    if current_user.nil?
      return true
    end
    unless current_user.nil?
      if level > current_user.user_level
        return true
      end
    end

    return false
  end

  private
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :acceptance])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :acceptance])
    end

    def set_tags
      @tags = TopTagList.all.select(:id, :genre, :tag_name, :hurigana).order('hurigana asc')
    end
end
