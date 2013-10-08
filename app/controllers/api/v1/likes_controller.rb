class Api::V1::LikesController < Api::V1::BaseController

  inherit_resources

  def index
    args = params[:like]
    likes = Like.where(user_id: current_api_user.id, likable_type: args[:likable_type], likable_id: args[:likable_id])
    respond_to do |format|
      format.json { render json: likes }
    end
  end

  def create
    respond_to do |format|
      args = params[:like]

      likes = Like.where(user_id: current_api_user.id, likable_type: args[:likable_type], likable_id: args[:likable_id])
      likes.destroy_all

      like = Like.new(user_id: current_api_user.id, likable_type: args[:likable_type], likable_id: args[:likable_id], status: args[:status])
      if like.save
        all_likes = Like.where(likable_id: args[:likable_id], likable_type: args[:likable_type])
        likes = all_likes.where(status: 1).count
        dislikes = all_likes.where(status: 0).count
        format.json { render json: { like: like, likes: likes, dislikes: dislikes } }
      else
        format.json { render :json => "Error saving like.", :status => :unprocessable_entity }
      end
    end
  end

end
