class Api::V1::MediaTagsController < Api::V1::BaseController

  inherit_resources

  def create
    respond_to do |format|
      tag_ids = params[:tag_ids]
      tag_types = params[:tag_types]
      tags = [tag_ids, tag_types].transpose

      mediable_id = params[:mediable_id]
      mediable_type = params[:mediable_type]
      temp_user_id = params[:temp_user_id] ? params[:temp_user_id] : 0
      user_id = current_api_user ? current_api_user.id : 0

      tags.each do |tag|
        media_tag = MediaTag.where(taggable_id: tag[0], taggable_type: tag[1], mediable_id: mediable_id, mediable_type: mediable_type)
        if media_tag.count == 0
          MediaTag.create(taggable_id: tag[0], taggable_type: tag[1], mediable_id: mediable_id, mediable_type: mediable_type, temp_user_id: temp_user_id, user_id: user_id)
        end
      end
      format.json { render json: { status: "success" } }
    end
  end

  def destroy
    respond_to do |format|
      user_id = current_api_user ? current_api_user.id : "-1"
      media_tag = MediaTag.where("(mediable_id = ? AND mediable_type = ? AND taggable_type = ? AND taggable_id = ?) AND (user_id = ? OR temp_user_id = ?)",
                                 params[:mediable_id], params[:mediable_type], params[:taggable_type], params[:taggable_id], user_id, params[:temp_user_id])
      if media_tag.destroy_all
        format.json { render json: { status: "success" } }
      else
        format.json { render json: { status: "error" } }
      end
    end
  end

  def update
    respond_to do |format|
      if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type)
        media_tag = MediaTag.where(mediable_id: params[:media_tag][:mediable_id], mediable_type: params[:media_tag][:mediable_type], taggable_type: params[:media_tag][:taggable_type], taggable_id: params[:media_tag][:taggable_id])
        if media_tag.count > 0
          media_tag = media_tag.first
          media_tag.approved = params[:media_tag][:approved]
          if media_tag.save
            tag = params[:media_tag][:taggable_type].classify.constantize.find(params[:media_tag][:taggable_id])
            tag.approved = true
            tag.save
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
