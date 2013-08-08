object @list
attributes :id,:description, :title, :user_id, :created_at, :updated_at
node(:user) { |list| list.user }
