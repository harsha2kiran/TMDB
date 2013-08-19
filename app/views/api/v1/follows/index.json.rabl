object @follows
attributes :id,:approved, :followable_id, :followable_type, :user_id, :created_at, :updated_at
node(:followed_content) { |follow| follow.followable_type.classify.constantize.find_by_id(follow.followable_id) }
