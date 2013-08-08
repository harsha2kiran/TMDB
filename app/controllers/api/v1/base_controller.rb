class Api::V1::BaseController < ApplicationController

  respond_to :json

  before_filter :set_controller_name
  # before_filter :check_if_authenticated
  before_filter :set_params_user_id

  private

  def set_controller_name
    @controller = params[:controller].gsub("api/v1/", "")
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
    attribute_names = @controller.classify.constantize.attribute_names
    if params[:action] == "create"
      if current_user && attribute_names.include?("user_id")
        params["#{@controller.singularize.to_sym}"][:user_id] = current_user.id
      else
        # comment this
        if attribute_names.include?("user_id")
          params["#{@controller.singularize.to_sym}"][:user_id] = User.first.id
        end
        # comment end
        #uncomment authenticate_user!
        # authenticate_user!
      end
    end
  end

end
