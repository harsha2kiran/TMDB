object @crews
attributes :id, :approved, :job, :movie_id, :person_id, :created_at, :updated_at
node(:person){ |crew|
  Person.find crew.person_id
}
