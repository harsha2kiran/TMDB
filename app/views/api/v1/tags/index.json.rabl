object @tags
attributes :id, :approved, :person_id, :taggable_type, :created_at, :updated_at
node(:tagged_content) { |tagged_content| tagged_content.taggable_type.classify.constantize.find_by_id(tagged_content.taggable_id) }

node(:person){ |tagged_content|
  @people.select {|s| tagged_content.person_id == s.id }[0]
}
node(:movie){ |tagged_content|
  @movies.select {|s| (tagged_content.taggable_id == s.id && tagged_content.taggable_type == "Movie") }[0]
}

