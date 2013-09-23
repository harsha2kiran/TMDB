object @crews
attributes :id, :approved, :job, :movie_id, :person_id, :created_at, :updated_at
if @people
  node(:person){ |crew|
    @people.select {|s| crew.person_id == s.id }[0]
  }
end
if @movies
  node(:movie){ |crew|
    @movies.select {|s| crew.movie_id == s.id }[0]
  }
end
