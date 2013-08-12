if @all
  object @alternative_names
  attributes :id, :alternative_name, :approved, :person_id, :created_at, :updated_at
  node(:person){ |alternative_name|
    Person.find alternative_name.person_id
  }
else
end
