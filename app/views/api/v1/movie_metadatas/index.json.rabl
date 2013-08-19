object @movie_metadatas
attributes :id, :approved, :budget, :homepage, :imdb_id, :movie_id, :movie_type_id, :runtime, :status_id, :created_at, :updated_at
node(:status){ |movie_metadata|
  Status.find_by_id movie_metadata.status_id
}
