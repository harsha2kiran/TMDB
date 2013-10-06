class Api::V1::ListTagsController < Api::V1::BaseController

  inherit_resources

  def create
    respond_to do |format|
      tag_ids = params[:tag_ids]
      tag_types = params[:tag_types]
      tags = [tag_ids, tag_types].transpose

      listable_id = params[:listable_id]
      listable_type = params[:listable_type]
      temp_user_id = params[:temp_user_id] ? params[:temp_user_id] : 0
      user_id = current_api_user ? current_api_user.id : 0

      tags.each do |tag|
        list_tag = ListTag.where(taggable_id: tag[0], taggable_type: tag[1], listable_id: listable_id, listable_type: listable_type)
        if list_tag.count == 0
          ListTag.create(taggable_id: tag[0], taggable_type: tag[1], listable_id: listable_id, listable_type: listable_type, temp_user_id: temp_user_id, user_id: user_id)
        end
      end
      format.json { render json: { status: "success" } }
    end
  end

  def destroy
    respond_to do |format|
      if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type)
        list_tag = ListTag.where(taggable_id: params[:taggable_id], taggable_type: params[:taggable_type], listable_id: params[:listable_id], listable_type: params[:listable_type])
        if list_tag.destroy_all
          format.json { render json: { status: "success" } }
        else
          format.json { render json: { status: "error" } }
        end
      end
    end
  end

  def update
    respond_to do |format|
      if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type)
        list_tag = ListTag.where(taggable_id: params[:list_tag][:taggable_id], taggable_type: params[:list_tag][:taggable_type], listable_id: params[:list_tag][:listable_id], listable_type: params[:list_tag][:listable_type])
        if list_tag.count > 0
          list_tag = list_tag.first
          list_tag.approved = params[:list_tag][:approved]
          if list_tag.save
            item = params[:list_tag][:taggable_type].classify.constantize.find(params[:list_tag][:taggable_id])
            item.approved = true
            item.save
            format.json { render json: { status: "success" } }
          else
            format.json { render json: { status: "error" } }
          end
        else
          format.json { render json: { status: "error" } }
        end
      end
    end
  end

end
