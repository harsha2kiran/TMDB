class Api::V1::UsersController < Api::V1::BaseController

  inherit_resources

  before_filter :set_default_user_type

  def set_default_user_type
    if params[:action] == "create"
      params[:user][:user_type] = "user"
    end
    if params[:action] == "update"
      if current_user.user_type != "admin"
        params[:user][:user_type] = "user"
      end
    end
  end

end
