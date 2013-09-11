object @follows
attributes :id,:approved, :followable_id, :followable_type, :user_id, :created_at, :updated_at
node(:followed_content) { |follow|
  if follow.followable_type == "Movie"
    @movies.select {|s| follow.followable_id == s.id }[0]
  elsif follow.followable_type == "Person"
    @people.select {|s| follow.followable_id == s.id }[0]
  elsif follow.followable_type == "List"
    @lists.select {|s| follow.followable_id == s.id }[0]
  elsif follow.followable_type == "Genre"
    @genres.select {|s| follow.followable_id == s.id }[0]
  end
}
