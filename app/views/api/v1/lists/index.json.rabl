object @lists
attributes :id,:description, :title, :user_id, :created_at, :updated_at, :list_type

child :list_items do
  attributes :id, :approved, :list_id, :listable_id, :listable_type, :created_at, :updated_at
  node(:images){ |item|
    if item.listable_type != "Image"
      r = item.listable_type.classify.constantize.where(approved: true).find_all_by_id(item.listable_id)
      if r.length > 0
        r.first.images
      end
    else
      Image.where(id: item.listable_id, approved: true)
    end
  }
  node(:videos){ |item|
    if item.listable_type != "Video"
      r = item.listable_type.classify.constantize.where(approved: true).find_all_by_id(item.listable_id)
      if r.length > 0
        r.first.videos
      end
    else
      Video.where(id: item.listable_id, approved: true)
    end
  }
end

node(:user){ |list|
  if list.user && list.user.first_name && list.user.last_name
    list.user.first_name + " " + list.user.last_name
  else
    ""
  end
}
