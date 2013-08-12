class Api::V1::ApprovalsController < ApplicationController

  respond_to :json

  def mark
    respond_to do |format|
      #TODO remove next line
      current_user = User.where(user_type: "admin").first
      if ["admin", "moderator"].include?(current_user.user_type)
        id = params[:id]
        type = params[:type]
        mark = params[:mark]
        item = type.classify.constantize.find id
        item.approved = mark
        if item.save
          format.json { render json: item }
        else
          format.json { render :json => "Error approving content.", :status => :unprocessable_entity }
        end
      else
        format.json { render :json => "Error: current user is not admin or moderator.", :status => :unprocessable_entity }
      end
    end
  end

end
