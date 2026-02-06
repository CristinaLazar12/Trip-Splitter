class ThemePagesController < ApplicationController
  skip_before_action :require_login, only: [:pinwheel]

  def pinwheel
  end
  
end