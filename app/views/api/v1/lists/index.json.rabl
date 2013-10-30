object @lists
attributes :id,:description, :title, :user_id, :created_at, :updated_at, :list_type, :approved

child :list_items do
  attributes :id, :approved, :list_id, :listable_id, :listable_type, :created_at, :updated_at
  node(:images){ |item|
    if @images && @images.length > 0
      if item.listable_type != "Image"
        r = item.listable_type.classify.constantize.where(approved: true).find_all_by_id(item.listable_id)
        if r.length > 0
          r.first.images
        end
      else
        @images.select{ |image| image.id == item.listable_id && image.approved == true }
      end
    end
  }

  node(:videos){ |item|
    if @videos && @videos.length > 0
      if item.listable_type != "Video"
        r = item.listable_type.classify.constantize.where(approved: true).find_all_by_id(item.listable_id)
        if r.length > 0
          r.first.videos
        end
      else
        @videos.select{ |video| video.id == item.listable_id && video.approved == true }
      end
    end
  }
end

node(:user){ |list|
  if list.user && list.user.first_name && list.user.last_name && list.user.first_name != "" && list.user.last_name != ""
    list.user.first_name + " " + list.user.last_name
  else
    list.user.email
  end
}

node(:pending){ |list|
  pending = false

  # check if pending list item
  if pending != true
    list.list_items.each do |item|
      if item.approved != true
        pending = true
      end
    end
  end

  # check if pending list_keyword
  if pending != true
    pending_keywords = ListKeyword.where("listable_id = ? AND listable_type = ?", list.id, list.list_type)
    pending_keywords.each do |keyword|
      if keyword.approved != true
        pending = true
      end
    end
  end

  # check if pending list_keyword
  if pending != true
    pending_tags = ListTag.where("listable_id = ? AND listable_type = ?", list.id, list.list_type)
    pending_tags.each do |tag|
      if tag.approved != true
        pending = true
      end
    end
  end

  pending
}
