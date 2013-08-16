object @movie_languages
attributes :id, :approved, :language_id, :movie_id, :created_at, :updated_at
node(:language){ |movie_language|
  Language.find movie_language.language_id
}
