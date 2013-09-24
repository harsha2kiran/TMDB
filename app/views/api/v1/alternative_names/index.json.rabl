object @alternative_names
attributes :id, :alternative_name, :approved, :person_id, :created_at, :updated_at
if @original_person
  node(:person){ |alternative_name|
    @people.select {|s| alternative_name.person_id == s.id }[0]
  }
else
  node(:person){ |alternative_name|
    @people.select {|s| alternative_name.person_id == s.id && s.approved == true }[0]
  }
end
