object @movie_genres
attributes :id, :approved, :genre_id, :movie_id, :created_at, :updated_at
node(:genre){ |movie_genre|
  @genres.select {|s| movie_genre.genre_id == s.id }[0]
}
