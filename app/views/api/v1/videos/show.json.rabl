object @video
attributes :id, :approved, :link, :link_active, :priority, :quality, :videable_id, :videable_type, :video_type, :created_at, :updated_at, :title, :thumbnail, :description, :duration, :category, :duration

node(:tags){
  r = []
  @media_tags.each do |tag|
    r << tag.taggable_type.classify.constantize.find_all_by_id(tag.taggable_id).first
  end
  r
}

node(:keywords){
  if @current_api_user && ["admin", "moderator"].include?(@current_api_user.user_type)
    keywords = Keyword.find_all_by_id(@media_keywords.map(&:keyword_id))
  elsif @current_api_user && @current_api_user.user_type == "user"
    keywords = Keyword.find_all_by_id(@media_keywords.where("approved = true OR user_id = ?", @current_api_user.id).map(&:keyword_id))
  elsif params[:temp_user_id]
    keywords = Keyword.find_all_by_id(@media_keywords.where("approved = true OR temp_user_id = ?", params[:temp_user_id]).map(&:keyword_id))
  else
    keywords = Keyword.find_all_by_id(@media_keywords.where(approved: true).map(&:keyword_id))
  end
  keywords
}

node(:media_tags){
  @media_tags
}

node(:media_keywords){
  @media_keywords
}

node(:follows) { |video| video.follows }
node(:views) { |video| video.views.count }
node(:likes) { |video| video.likes.where(status: 1) }
node(:dislikes) { |video| video.likes.where(status: 0) }
