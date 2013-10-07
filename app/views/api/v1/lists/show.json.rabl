# object @list
# attributes :id,:description, :title, :user_id, :created_at, :updated_at, :list_type

# if @list
#   child :list_items do
#     attributes :id, :approved, :list_id, :listable_id, :listable_type, :created_at, :updated_at, :approved, :user_id, :temp_user_id
#     node(:images){ |item|
#       if item.listable_type != "Image"
#         r = item.listable_type.classify.constantize.where(approved: true).find_all_by_id(item.listable_id)
#         if r.length > 0
#           r.first.images
#         end
#       else
#         if @current_api_user && ["admin", "moderator"].include?(@current_api_user.user_type)
#           Image.where(id: item.listable_id)
#         elsif @current_api_user && @current_api_user.user_type == "user"
#           Image.where("id = ? AND (approved = true OR user_id = ?)", item.listable_id, @current_api_user.id)
#         elsif params[:temp_user_id]
#           Image.where("id = ? AND (approved = true OR temp_user_id = ?)", item.listable_id, params[:temp_user_id])
#         else
#           Image.where(id: item.listable_id, approved: true)
#         end
#       end
#     }

#     node(:listable_item){ |item|
#       if @current_api_user && ["admin", "moderator"].include?(@current_api_user.user_type)
#         r = item.listable_type.classify.constantize.where(id: item.listable_id)
#       elsif @current_api_user && @current_api_user.user_type == "user"
#         r = item.listable_type.classify.constantize.where("approved = true OR user_id = ?", @current_api_user.id).find_all_by_id(item.listable_id)
#       elsif params[:temp_user_id]
#         r = item.listable_type.classify.constantize.where("approved = true OR temp_user_id = ?", params[:temp_user_id]).find_all_by_id(item.listable_id)
#       else
#         r = item.listable_type.classify.constantize.where("approved = true").find_all_by_id(item.listable_id)
#       end
#       if r.length > 0
#         r.first
#       end
#     }
#   end

#   node(:keywords){
#     Keyword.find_all_by_id(@keywords.map(&:keyword_id))
#   }

#   node(:tags){
#     r = []
#     @tags.each do |tag|
#       r << tag.taggable_type.classify.constantize.find_all_by_id(tag.taggable_id).first
#     end
#     r
#   }

#   node(:user){ |list|
#     if list.user && list.user.first_name && list.user.last_name && list.user.first_name != "" && list.user.last_name != ""
#       list.user.first_name + " " + list.user.last_name
#     else
#       list.user.email
#     end
#   }
#   node(:user_id){ |list|
#     list.user.id
#   }
#   node(:follows) { |list|
#     if @current_api_user
#       list.follows.where(user_id: @current_api_user.id)
#     else
#       []
#     end
#   }
# end






object @list
attributes :id,:description, :title, :user_id, :created_at, :updated_at, :list_type, :approved

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
        if @current_api_user && ["admin", "moderator"].include?(@current_api_user.user_type)
          @images.select{ |image| image.id == item.listable_id } #Image.where(id: item.listable_id)
        elsif @current_api_user && @current_api_user.user_type == "user"
          @images.select{ |image| image.id == item.listable_id && (image.approved == true || image.user_id == @current_api_user.id) } #Image.where("id = ? AND (approved = true OR user_id = ?)", item.listable_id, @current_api_user.id)
        elsif params[:temp_user_id]
          @images.select{ |image| image.id == item.listable_id && (image.approved == true || image.temp_user_id == params[:temp_user_id]) } #Image.where("id = ? AND (approved = true OR temp_user_id = ?)", item.listable_id, params[:temp_user_id])
        else
          @images.select{ |image| image.id == item.listable_id && image.approved == true } #Image.where(id: item.listable_id, approved: true)
        end
      end
    }

    node(:listable_item){ |item|
      if item.listable_type != "Image"
        if @current_api_user && ["admin", "moderator"].include?(@current_api_user.user_type)
          r = item.listable_type.classify.constantize.where(id: item.listable_id)
        elsif @current_api_user && @current_api_user.user_type == "user"
          r = item.listable_type.classify.constantize.where("approved = true OR user_id = ?", @current_api_user.id).find_all_by_id(item.listable_id)
        elsif params[:temp_user_id]
          r = item.listable_type.classify.constantize.where("approved = true OR temp_user_id = ?", params[:temp_user_id]).find_all_by_id(item.listable_id)
        else
          r = item.listable_type.classify.constantize.where("approved = true").find_all_by_id(item.listable_id)
        end
        if r.length > 0
          r.first
        end
      else
        if @current_api_user && ["admin", "moderator"].include?(@current_api_user.user_type)
          images = @images.select{ |image| image.id == item.listable_id } #Image.where(id: item.listable_id)
        elsif @current_api_user && @current_api_user.user_type == "user"
          images = @images.select{ |image| image.id == item.listable_id && (image.approved == true || image.user_id == @current_api_user.id) } #Image.where("id = ? AND (approved = true OR user_id = ?)", item.listable_id, @current_api_user.id)
        elsif params[:temp_user_id]
          images = @images.select{ |image| image.id == item.listable_id && (image.approved == true || image.temp_user_id == params[:temp_user_id]) } #Image.where("id = ? AND (approved = true OR temp_user_id = ?)", item.listable_id, params[:temp_user_id])
        else
          images = @images.select{ |image| image.id == item.listable_id && image.approved == true } #Image.where(id: item.listable_id, approved: true)
        end
        images[0]
      end
    }
  end

  node(:keywords){
    if @current_api_user && ["admin", "moderator"].include?(@current_api_user.user_type)
      Keyword.find_all_by_id(@keywords.map(&:keyword_id))
    elsif @current_api_user && @current_api_user.user_type == "user"
      Keyword.find_all_by_id(@keywords.where("approved = true OR user_id = ?", @current_api_user.id).map(&:keyword_id))
    elsif params[:temp_user_id]
      Keyword.find_all_by_id(@keywords.where("approved = true OR temp_user_id = ?", params[:temp_user_id]).map(&:keyword_id))
    else
      Keyword.find_all_by_id(@keywords.where(approved: true).map(&:keyword_id))
    end
  }

  node(:list_keywords){
    if @current_api_user && ["admin", "moderator"].include?(@current_api_user.user_type)

    elsif @current_api_user && @current_api_user.user_type == "user"
      @keywords = @keywords.where("approved = true OR user_id = ?", @current_api_user.id)
    elsif params[:temp_user_id]
      @keywords = @keywords.where("approved = true OR temp_user_id = ?", params[:temp_user_id])
    else
      @keywords = @keywords.where(approved: true)
    end
    @keywords
  }

  node(:tags){
    r = []
    @tags.each do |tag|
      r << tag.taggable_type.classify.constantize.find_all_by_id(tag.taggable_id).first
    end
    r
  }

  node(:list_tags){
    if @current_api_user && ["admin", "moderator"].include?(@current_api_user.user_type)

    elsif @current_api_user && @current_api_user.user_type == "user"
      @tags = @tags.where("approved = true OR user_id = ?", @current_api_user.id)
    elsif params[:temp_user_id]
      @tags = @tags.where("approved = true OR temp_user_id = ?", params[:temp_user_id])
    else
      @tags = @tags.where(approved: true)
    end
    @tags
  }

  node(:user){ |list|
    if list.user && list.user.first_name && list.user.last_name && list.user.first_name != "" && list.user.last_name != ""
      list.user.first_name + " " + list.user.last_name
    else
      list.user.email
    end
  }
  node(:user_id){ |list|
    list.user.id
  }
  node(:follows) { |list|
    if @current_api_user
      list.follows.where(user_id: @current_api_user.id)
    else
      []
    end
  }
end
