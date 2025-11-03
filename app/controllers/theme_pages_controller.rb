class ThemePagesController < ApplicationController
  skip_before_action :require_authentication, only: [:pinwheel]


  def pinwheel
  end
  
end