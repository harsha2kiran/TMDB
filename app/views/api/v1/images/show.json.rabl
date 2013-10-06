object @image
attributes :id, :approved, :image_file, :image_type, :is_main_image, :imageable_id, :imageable_type, :title, :priority, :created_at, :updated_at, :description
# node(:videos) { |image| image.videos }
# node(:tags) { |image|
#   partial("api/v1/tags/index", :object => image.tags.select {|s| s.approved == true } )
# }
node(:tags){
  r = []
  @media_tags.each do |tag|
    r << tag.taggable_type.classify.constantize.find_all_by_id(tag.taggable_id).first
  end
  r
}

node(:media_tags){
  @media_tags
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

node(:media_keywords){
  @media_keywords
}

node(:follows) { |image| image.follows }
node(:views) { |image| image.views.count }
