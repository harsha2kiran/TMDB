object @movie_keywords
attributes :id, :approved, :keyword_id, :movie_id, :created_at, :updated_at
node(:keyword){ |movie_keyword|
  @keywords.select{|s| movie_keyword.keyword_id == s.id }[0]
}
