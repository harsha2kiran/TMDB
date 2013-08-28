object @tags
attributes :id, :approved, :person_id, :taggable_type, :created_at, :updated_at, :taggable_id
node(:tagged_content) { |tagged_content|
  if tagged_content.taggable_type == "Movie"
    if @movies
      @movies.select {|s| (tagged_content.taggable_id == s.id && tagged_content.taggable_type == "Movie") }[0]
    end
  elsif tagged_content.taggable_type == "Person" || tagged_content.taggable_type == "Image"
    if @people
      @people.select {|s| tagged_content.person_id == s.id }[0]
    end
  end
  # tagged_content.taggable_type.classify.constantize.find_by_id(tagged_content.taggable_id)
}

node(:person){ |tagged_content|
  if @people
    @people.select {|s| tagged_content.person_id == s.id }[0]
  end
}
node(:movie){ |tagged_content|
  if @movies
    @movies.select {|s| (tagged_content.taggable_id == s.id && tagged_content.taggable_type == "Movie") }[0]
  end
}

