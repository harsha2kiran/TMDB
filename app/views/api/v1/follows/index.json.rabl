object @follows
attributes :id,:approved, :followable_id, :followable_type, :user_id, :created_at, :updated_at
node(:followed_content) { |follow|
  if follow.followable_type == "Movie"
    @movies.select {|s| follow.followable_id == s.id }[0]
  else
    @people.select {|s| follow.followable_id == s.id }[0]
  end
}
