object @movie_metadatas
attributes :id, :approved, :budget, :homepage, :imdb_id, :movie_id, :movie_type_id, :runtime, :status_id, :created_at, :updated_at, :user_id, :temp_user_id
node(:status){ |movie_metadata|
  @statuses.select {|s| movie_metadata.status_id == s.id }[0]
}
