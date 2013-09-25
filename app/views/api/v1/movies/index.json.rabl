object @movies
attributes :id, :original_id, :user_id, :approved, :content_score, :locked, :overview, :tagline, :title, :created_at, :updated_at

if @all
  node(:images) { |movie| movie.images }
else
  node(:images) { |movie|
    movie.images.select {|s| s.approved == true }
  }
end
