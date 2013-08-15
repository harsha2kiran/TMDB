class Api::V1::UsersController < Api::V1::BaseController

  # inherit_resources

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

  def show
    @user = User.where(active: 1).find(params[:id])
  end

  def get_current_user
    @user = current_user
    render 'show'
  end

  def toggle_active
    respond_to do |format|
      #TODO remove this line
      current_user = User.find params[:user_id]
      current_user.active = params[:user][:toggle_active]
      if current_user.save
        format.json { respond_with current_user.active }
      else
        format.json { render :json => "Error updating user.", :status => :unprocessable_entity }
      end
    end
  end

end
