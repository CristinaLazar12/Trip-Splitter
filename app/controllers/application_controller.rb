class ApplicationController < ActionController::Base 
  allow_browser versions: :modern 
  helper_method :current_user, :logged_in?

  before_action :require_login
  
  private 

    def current_user
      @current_user ||= User.find_by(id: session[:current_user_id]) if session[:current_user_id]
    end

    def logged_in?
      current_user.present?
    end

    def require_login
      unless logged_in?
        flash[:alert] = "You must be logged in to access this section"
        redirect_to new_session_path
      end
    end
end