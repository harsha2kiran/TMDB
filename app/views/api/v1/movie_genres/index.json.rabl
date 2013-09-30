object @movie_genres
attributes :id, :approved, :genre_id, :movie_id, :created_at, :updated_at, :user_id, :temp_user_id
if @original_movie
  node(:genre){ |movie_genre|
    @genres.select {|s| movie_genre.genre_id == s.id }[0]
  }
else
  node(:genre){ |movie_genre|
    @genres.select {|s| movie_genre.genre_id == s.id && s.approved == true }[0]
  }
end
