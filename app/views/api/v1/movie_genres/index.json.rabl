object @movie_genres
attributes :id, :approved, :genre_id, :movie_id, :created_at, :updated_at
node(:person){ |movie_genre|
  Genre.find movie_genre.genre_id
}
