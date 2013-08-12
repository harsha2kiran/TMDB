object @tags
attributes :id, :approved, :person_id, :taggable_type, :created_at, :updated_at
node(:tagged_content) { |tag| tag.taggable_type.classify.constantize.find(tag.taggable_id) }
node(:person){ |tag|
  Person.find tag.person_id
}
