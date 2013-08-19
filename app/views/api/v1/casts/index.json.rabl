object @casts
attributes :id, :approved, :character, :movie_id, :person_id, :created_at, :updated_at
node(:person){ |cast|
  @people.select {|s| cast.person_id == s.id }[0]
}
node(:movie){ |cast|
  @movies.select {|s| cast.movie_id == s.id }[0]
}
