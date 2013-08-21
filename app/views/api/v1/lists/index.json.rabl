object @lists
attributes :id,:description, :title, :user_id, :created_at, :updated_at

child :list_items do
  attributes :id, :approved, :list_id, :listable_id, :listable_type, :created_at, :updated_at
  node(:images){ |item|
    item.listable_type.classify.constantize.where(id: item.listable_id, approved: true).first.images
  }
end

node(:user){ |list|
  if list.user && list.user.first_name && list.user.last_name
    list.user.first_name + " " + list.user.last_name
  else
    ""
  end
}
