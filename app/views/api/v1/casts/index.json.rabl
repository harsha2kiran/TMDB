object @casts
attributes :id, :approved, :character, :movie_id, :person_id, :created_at, :updated_at
if @people
  if @original_movie || @original_person
    node(:person){ |cast|
      @people.select {|s| cast.person_id == s.id }[0]
    }
  else
    node(:person){ |cast|
      @people.select {|s| cast.person_id == s.id && s.approved == true }[0]
    }
  end
end
if @movies
  if @original_movie || @original_person
    node(:movie){ |cast|
      @movies.select {|s| cast.movie_id == s.id }[0]
    }
  else
    node(:movie){ |cast|
      @movies.select {|s| cast.movie_id == s.id }[0]
    }
  end
end

