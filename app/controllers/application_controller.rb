class ApplicationController < ActionController::Base
  protect_from_forgery

  def index

  end

  def authenticate_admin_user!
    redirect_to root_path unless current_user.user_type == "admin"
  end

end
