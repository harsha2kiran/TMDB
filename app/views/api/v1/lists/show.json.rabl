object @list
attributes :id,:description, :title, :user_id, :created_at, :updated_at, :list_type

if @list
  child :list_items do
    attributes :id, :approved, :list_id, :listable_id, :listable_type, :created_at, :updated_at, :approved, :user_id, :temp_user_id
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
    node(:listable_item){ |item|
      if item.listable_type != "Image"
        if @current_api_user
          r = item.listable_type.classify.constantize.where("approved = true OR user_id = ?", @current_api_user.id).find_all_by_id(item.listable_id)
        else
          r = item.listable_type.classify.constantize.where("approved = true OR temp_user_id = ?", params[:temp_user_id]).find_all_by_id(item.listable_id)
        end
        if r.length > 0
          r.first
        end
      else
        Image.where(id: item.listable_id, approved: true)
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
  node(:follows) { |list|
    if @current_api_user
      list.follows.where(user_id: @current_api_user.id)
    else
      []
    end
  }
end
