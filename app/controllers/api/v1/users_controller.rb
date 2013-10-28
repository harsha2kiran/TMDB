class Api::V1::UsersController < Api::V1::BaseController

  # inherit_resources

  before_filter :set_default_user_type

  def set_default_user_type
    if params[:action] == "create"
      params[:user][:user_type] = "user"
    end
    if params[:action] == "update"
      if current_api_user.user_type != "admin"
        params[:user][:user_type] = "user"
      end
    end
  end

  def show
    if params[:moderate] && params[:moderate] == "true"
      @user = User.find(params[:id])
    else
      @user = User.where(active: 1).find(params[:id])
    end
  end

  def update
    if current_api_user && current_api_user.user_type == "admin"
      @user = User.find(params[:id])
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.json { respond_with @user }
        else
          format.json { render :json => "Error updating user.", :status => :unprocessable_entity }
        end
      end
    end
  end

  def get_current_user
    if current_api_user
      @user = current_api_user
    else
      @user = []
    end
    render 'show'
  end

  def toggle_active
    respond_to do |format|
      current_api_user.active = params[:user][:toggle_active]
      if current_api_user.save
        format.json { respond_with current_api_user.active }
      else
        format.json { render :json => "Error updating user.", :status => :unprocessable_entity }
      end
    end
  end

end
