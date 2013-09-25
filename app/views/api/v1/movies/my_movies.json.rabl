object @movies
attributes :id, :original_id, :user_id, :approved, :content_score, :locked, :overview, :tagline, :title, :created_at, :updated_at

if @all
  node(:images) { |movie| movie.images }
else
  node(:images) { |movie|
    if @current_api_user
      movie.images.select {|s| (s.approved == true || s.user_id == @current_api_user.id) }
    else
      movie.images.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) }
    end
  }
end
