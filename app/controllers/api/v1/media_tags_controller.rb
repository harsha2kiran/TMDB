class Api::V1::MediaTagsController < Api::V1::BaseController

  inherit_resources

  def create
    tag_ids = params[:tag_ids]
    tag_types = params[:tag_types]
    tags = [tag_ids, tag_types].transpose

    mediable_id = params[:mediable_id]
    mediable_type = params[:mediable_type]
    temp_user_id = params[:temp_user_id] ? params[:temp_user_id] : 0
    user_id = current_api_user ? current_api_user.id : 0

    tags.each do |tag|
      MediaTag.create(taggable_id: tag[0], taggable_type: tag[1], mediable_id: mediable_id, mediable_type: mediable_type, temp_user_id: temp_user_id, user_id: user_id)
    end
    render nothing: true
  end

end
