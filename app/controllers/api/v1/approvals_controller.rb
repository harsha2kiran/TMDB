class Api::V1::ApprovalsController < Api::V1::BaseController

  respond_to :json

  def mark
    respond_to do |format|
      if ["admin", "moderator"].include?(current_api_user.user_type)
        type = params[:type]
        mark = params[:mark]
        if ["Movie", "Person"].include?(type)
          original_id = params[:original_id]
          approved_id = params[:approved_id]

          if original_id == approved_id
            original_record = type.classify.constantize.find(original_id)
            original_record.approved = mark
            original_record.save
            format.json { render json: original_record }
          else
            # get currently active item and duplicate it for backup
            original_record = type.classify.constantize.where(id: original_id)
            if original_record.count > 0
              original_record = original_record.first
              backup_status = backup_original(original_record)

              # get the approved record
              approved_record = type.classify.constantize.where(id: approved_id)
              if approved_record.count > 0
                approved_record = approved_record.first
                approved_values = approved_record.attributes
                approved_values  = approved_values.except("id", "created_at", "updated_at")
                approved_values["approved"] = mark
                unless approved_values["user_id"]
                  approved_values["user_id"] = current_api_user.id
                end

                # update currently active item with new approved values
                original_record.approved = true
                if original_record.update_attributes(approved_values)
                  if approved_record.user_id
                    user = User.find approved_record.user_id
                    add_points_to_user(user)
                    add_badges_to_user(user)
                  end
                  # update foreign keys (ids) on each related table according to item type
                  approved_record.destroy
                  format.json { render json: original_record }
                else
                  format.json { render :json => "Error approving content.", :status => :unprocessable_entity }
                end
              else
                if backup_status
                  type.classify.constantize.last.destroy
                end
                format.json { render :json => "Error approving content not found.", :status => :unprocessable_entity }
              end
            else
              format.json { render :json => "Error original content not found.", :status => :unprocessable_entity }
            end
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

  def main_items
    @type = params[:type]
    @items = @type.classify.constantize.where("id = original_id").order("created_at")
    render "main_items"
  end

  def main_item
    @type = params[:type]
    @id = params[:id]
    @item = @type.classify.constantize.where("original_id = ?", @id).order("created_at")
    render "main_item"
  end

  def items
    @type = params[:type]
    if @type == "MovieMetadata"
      @items = MovieMetadata.order("created_at")
    else
      @items = @type.classify.constantize.order("created_at")
    end
    render "items"
  end

  def item
    @type = params[:type]
    @id = params[:id]
    @item = @type.classify.constantize.where("id = ?", @id).order("created_at")
    render "item"
  end

  private

  def add_points_to_user(user)
    unless user.points
      user.points = 0
    end
    user.points = user.points + 10
    user.save
  end

  def add_badges_to_user(user)
    badges = Badge.where("min_points < ? OR min_points = ?", user.points, user.points)
    user_badges_ids = user.badges.map(&:id)
    badges.each do |badge|
      unless user_badges_ids.include?(badge.id)
        user.badges << badge
      end
    end
  end

  def backup_original(original_record)
    copy_record = original_record.clone
    copy_record.approved = false
    copy_values = copy_record.attributes
    copy_values = copy_values.except("id", "created_at", "updated_at", "temp_user_id")
    new_copy_record = original_record.class.name.classify.constantize.new(copy_values)
    if new_copy_record.save
      true
    else
      false
    end
  end

end
