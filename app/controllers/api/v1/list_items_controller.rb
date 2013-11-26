class Api::V1::ListItemsController < Api::V1::BaseController

  inherit_resources

  def create
    respond_to do |format|
      list = List.find params[:list_item][:list_id]
      if current_api_user && (["admin", "moderator"].include?(current_api_user.user_type))
        # params[:list_item][:approved] = true
        params[:list_item][:user_id] = current_api_user.id
      else
        params[:list_item][:approved] = false
      end
      if list.list_items.create!(params[:list_item])
        format.json { render json: true }
      else
        format.json { render :json => "Error creating list item.", :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if ["admin", "moderator"].include?(current_api_user.user_type)
        list = List.find params[:list_item][:list_id]
      else
        list = current_api_user.lists.find params[:list_item][:list_id]
      end
      list_item = list.list_items.find params[:id]
      params[:list_item].delete :user_id
      if list_item.update_attributes(params[:list_item])
        if params[:list_item][:approved]
          if ["Image", "Video"].include?(list_item.listable_type)
            item = list_item.listable_type.classify.constantize.find(list_item.listable_id)
            item.approved = true
            item.save
            pending = PendingItem.where(pendable_id: list.id, pendable_type: "List", approvable_id: item.id, approvable_type: list_item.listable_type)
            pending.destroy_all
            pending = PendingItem.where(approvable_id: list_item.listable_id, approvable_type: list_item.listable_type)
            pending.destroy_all
          end
        end
        format.json { respond_with list_item }
      else
        format.json { render :json => "Error updating list item.", :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type)
        list_item = ListItem.find params[:id]
      elsif current_api_user && current_api_user.user_type = "user"
        list_item = ListItem.where(user_id: current_api_user.id).find(params[:id])
      elsif params[:temp_user_id]
        list_item = ListItem.where(temp_user_id: params[:temp_user_id]).find(params[:id])
      end
      if list_item.listable_type == "Video"
        video = Video.find(list_item.listable_id)
        video.destroy
      end
      if list_item.destroy
        format.json { respond_with list_item }
      else
        format.json { render :json => "Error removing list item.", :status => :unprocessable_entity }
      end
    end
  end

end
