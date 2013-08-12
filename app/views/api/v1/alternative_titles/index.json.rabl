object @alternative_titles
attributes :id, :alternative_title, :approved, :language_id, :movie_id, :created_at, :updated_at
node(:language){ |alternative_title|
  Language.find alternative_title.language_id
}
