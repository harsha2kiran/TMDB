class Api::V1::ApprovalsController < ApplicationController

  respond_to :json

  def mark
    respond_to do |format|
      #TODO remove next line
      current_user = User.where(user_type: "admin").first
      if ["admin", "moderator"].include?(current_user.user_type)
        type = params[:type]
        mark = params[:mark]
        if ["Movie", "Person"].include?(type)
          original_id = params[:original_id]
          approved_id = params[:approved_id]

          # get currently active item and duplicate it for backup
          original_record = backup_original(type, original_id)

          # get the approved record
          approved_record = type.classify.constantize.find approved_id
          approved_values = approved_record.attributes
          approved_values  = approved_values.except("id", "created_at", "updated_at")
          approved_values["approved"] = mark

          # update currently active item with new approved values
          original_record.approved = true
          if original_record.update_attributes(approved_values)
            approved_record.destroy
            format.json { render json: original_record }
          else
            format.json { render :json => "Error approving content.", :status => :unprocessable_entity }
          end
        else
          id = params[:approved_id]
          record = type.classify.constantize.find id
          record.approved = true
          if record.save
            format.json { render json: record }
          else
            format.json { render :json => "Error approving content.", :status => :unprocessable_entity }
          end
        end
      else
        format.json { render :json => "Error: current user is not admin or moderator.", :status => :unprocessable_entity }
      end
    end
  end

  private

  def backup_original(type, original_id)
    original_record = type.classify.constantize.find original_id
    copy_record = original_record.clone
    copy_record.approved = false
    copy_values = copy_record.attributes
    copy_values = copy_values.except("id", "created_at", "updated_at")
    new_copy_record = type.classify.constantize.new(copy_values)
    new_copy_record.save!
    original_record
  end

end
