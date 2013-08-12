object @movie_keywords
attributes :id, :approved, :keyword_id, :movie_id, :created_at, :updated_at
node(:keyword){ |movie_keyword|
  Keyword.find movie_keyword.keyword_id
}
