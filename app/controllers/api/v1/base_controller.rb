class Api::V1::BaseController < ApplicationController

  respond_to :json, :js

  before_filter :set_controller_name
  # before_filter :check_if_authenticated
  before_filter :set_params_user_id
  before_filter :set_approved_false
  before_filter :check_if_destroy
  before_filter :check_if_update

  private

  def set_controller_name
    @controller = params[:controller].gsub("api/v1/", "")
    @attribute_names = @controller.classify.constantize.attribute_names
  end

  def check_if_authenticated
    logger.info "controller " + @controller
    logger.info "action " + params[:action]
    public_controllers = ["movies", "videos", "images", "lists", "people"]
    if public_controllers.include?(@controller) && (params[:action] == "index" || params[:action] == "show")
      # no need to authenticate, these are public resources
    else
      authenticate_user!
    end
  end

  def set_params_user_id
    if ["create", "update"].include?(params[:action])
      # add user_id value from current_user or redirect to login.
      # check if current model has attribute user_id, if not, skip it
      if current_user && @attribute_names.include?("user_id")
        params["#{@controller.singularize.to_sym}"][:user_id] = current_user.id
      else
        # comment this
        if @attribute_names.include?("user_id")
          params["#{@controller.singularize.to_sym}"][:user_id] = User.first.id
        end
        # comment end
        #uncomment authenticate_user!
        # authenticate_user!
      end
    end
  end

  def set_approved_false
    # add approved = false value to record on create if column exist
    if params[:action] == "create"
      #TODO uncomment last part of next line
      if @attribute_names.include?("approved") # && current_user.user_type != "admin"
        params["#{@controller.singularize.to_sym}"][:approved] = false
      else
        params["#{@controller.singularize.to_sym}"][:approved] = true
      end
    end
  end

  def check_if_destroy
    if params[:action] == "destroy"
      if current_user && current_user.user_type == "admin"
      else
        redirect_to root_path, alert: "You must have admin privileges to remove record."
      end
    else
    end
  end

  def check_if_update
    if params[:action] == "update"
      if ["admin", "moderator"].include?(current_user.user_type)
      else
        redirect_to root_path, alert: "You must have admin or moderator privileges to update record."
      end
    else
    end
  end

end
