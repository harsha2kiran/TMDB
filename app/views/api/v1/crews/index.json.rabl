object @crews
attributes :id, :approved, :job, :movie_id, :person_id, :created_at, :updated_at
if @people
  if @original_movie || @original_person
    node(:person){ |crew|
      @people.select {|s| crew.person_id == s.id }[0]
    }
  else
    node(:person){ |crew|
      @people.select {|s| crew.person_id == s.id && s.approved == true }[0]
    }
  end
end
if @movies
  if @original_movie || @original_person
    node(:movie){ |crew|
      @movies.select {|s| crew.movie_id == s.id }[0]
    }
  else
    node(:movie){ |crew|
      @movies.select {|s| crew.movie_id == s.id && s.approved == true }[0]
    }
  end
end
