object @alternative_names
attributes :id, :alternative_name, :approved, :person_id, :created_at, :updated_at
node(:person){ |alternative_name|
  @people.select {|s| alternative_name.person_id == s.id }[0]
}
