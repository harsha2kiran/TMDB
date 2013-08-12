object @movie_language
attributes :id, :approved, :language_id, :movie_id, :created_at, :updated_at
node(:keyword){ |movie_language|
  Language.find movie_language.language_id
}
