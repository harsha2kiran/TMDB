object @crews
attributes :id, :approved, :job, :movie_id, :person_id, :created_at, :updated_at
node(:person){ |crew|
  @people.select {|s| crew.person_id == s.id }[0]
}
node(:movie){ |crew|
  Movie.find crew.movie_id
}
