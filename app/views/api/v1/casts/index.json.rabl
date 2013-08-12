object @casts
attributes :id, :approved, :character, :movie_id, :person_id, :created_at, :updated_at
node(:person){ |cast|
  Person.find cast.person_id
}
