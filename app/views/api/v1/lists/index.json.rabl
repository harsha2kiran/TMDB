object @lists
attributes :id,:description, :title, :user_id, :created_at, :updated_at
node(:list_items) { |list| list.list_items }
