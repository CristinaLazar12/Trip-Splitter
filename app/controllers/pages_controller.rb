class PagesController < ApplicationController
    before_action :require_login, only: :dashboard

    def home
        redirect_to dashboard_path if logged_in?
    end

    def dashboard
        @trips = current_user.created_trips.order(created_at: :desc)
    end

    def calendar 
    end

end
