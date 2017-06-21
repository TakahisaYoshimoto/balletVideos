class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_tags
  after_action :store_location

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

  #ログイン後のパスを指定
  def after_sign_in_path_for(resource)
    if (session[:previous_url] == root_path)
      root_path
    else
      session[:previous_url] || root_path
    end
  end

  private
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :acceptance, :notice_email, :rule_confirmed])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :acceptance, :picture, :profile, :notice_email, :rule_confirmed])
    end

    def set_tags
      @tags = TopTagList.all.select(:id, :genre, :tag_name, :hurigana).order('hurigana asc')
      @board_tags = BoardTag.group(:name).order('count_name desc').limit(5).offset(0).count(:name)
    end

    def store_location
      if (request.fullpath != "/users/sign_in" &&
          request.fullpath != "/users/sign_up" &&
          request.fullpath != "/users/password" &&
          request.fullpath !~ Regexp.new("\\A/users/password.*\\z") &&
          !request.xhr?)
        session[:previous_url] = request.fullpath
      end
    end
end
