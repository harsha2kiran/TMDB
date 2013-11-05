object @list
attributes :id,:description, :title, :user_id, :created_at, :updated_at, :list_type, :approved

if @list
  child :list_items do
    attributes :id, :approved, :list_id, :listable_id, :listable_type, :created_at, :updated_at, :approved, :user_id, :temp_user_id
    node(:images){ |item|
      if item.listable_type == "Image"
        if @current_api_user && ["admin", "moderator"].include?(@current_api_user.user_type)
          @images.select{ |image| image.id == item.listable_id }
        elsif @current_api_user && @current_api_user.user_type == "user"
          @images.select{ |image| image.id == item.listable_id && (image.approved == true || image.user_id == @current_api_user.id) }
        elsif params[:temp_user_id]
          @images.select{ |image| image.id == item.listable_id && (image.approved == true || image.temp_user_id == params[:temp_user_id]) }
        else
          @images.select{ |image| image.id == item.listable_id && image.approved == true }
        end
      end
    }

    node(:videos){ |item|
      if item.listable_type == "Video"
        if @current_api_user && ["admin", "moderator"].include?(@current_api_user.user_type)
          videos = @videos.select{ |image| image.id == item.listable_id }
        elsif @current_api_user && @current_api_user.user_type == "user"
          videos = @videos.select{ |image| image.id == item.listable_id && (image.approved == true || image.user_id == @current_api_user.id) }
        elsif params[:temp_user_id]
          videos = @videos.select{ |image| image.id == item.listable_id && (image.approved == true || image.temp_user_id == params[:temp_user_id]) }
        else
          videos = @videos.select{ |image| image.id == item.listable_id && image.approved == true }
        end
      end
    }

    node(:listable_item){ |item|
      if item.listable_type == "Video"
        if @current_api_user && ["admin", "moderator"].include?(@current_api_user.user_type)
          videos = @videos.select{ |image| image.id == item.listable_id }
        elsif @current_api_user && @current_api_user.user_type == "user"
          videos = @videos.select{ |image| image.id == item.listable_id && (image.approved == true || image.user_id == @current_api_user.id) }
        elsif params[:temp_user_id]
          videos = @videos.select{ |image| image.id == item.listable_id && (image.approved == true || image.temp_user_id == params[:temp_user_id]) }
        else
          videos = @videos.select{ |image| image.id == item.listable_id && image.approved == true }
        end
        videos[0]
      elsif item.listable_type == "Image"
        if @current_api_user && ["admin", "moderator"].include?(@current_api_user.user_type)
          images = @images.select{ |image| image.id == item.listable_id }
        elsif @current_api_user && @current_api_user.user_type == "user"
          images = @images.select{ |image| image.id == item.listable_id && (image.approved == true || image.user_id == @current_api_user.id) }
        elsif params[:temp_user_id]
          images = @images.select{ |image| image.id == item.listable_id && (image.approved == true || image.temp_user_id == params[:temp_user_id]) }
        else
          images = @images.select{ |image| image.id == item.listable_id && image.approved == true }
        end
        images[0]
      elsif item.listable_type == "Movie"
        if @current_api_user && ["admin", "moderator"].include?(@current_api_user.user_type)
          movies = @movies.select{ |image| image.id == item.listable_id }
        elsif @current_api_user && @current_api_user.user_type == "user"
          movies = @movies.select{ |image| image.id == item.listable_id && (image.approved == true || image.user_id == @current_api_user.id) }
        elsif params[:temp_user_id]
          movies = @movies.select{ |image| image.id == item.listable_id && (image.approved == true || image.temp_user_id == params[:temp_user_id]) }
        else
          movies = @movies.select{ |image| image.id == item.listable_id && image.approved == true }
        end
        movies[0]
      elsif item.listable_type == "Person"
        if @current_api_user && ["admin", "moderator"].include?(@current_api_user.user_type)
          people = @people.select{ |image| image.id == item.listable_id }
        elsif @current_api_user && @current_api_user.user_type == "user"
          people = @people.select{ |image| image.id == item.listable_id && (image.approved == true || image.user_id == @current_api_user.id) }
        elsif params[:temp_user_id]
          people = @people.select{ |image| image.id == item.listable_id && (image.approved == true || image.temp_user_id == params[:temp_user_id]) }
        else
          people = @people.select{ |image| image.id == item.listable_id && image.approved == true }
        end
        people[0]
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
    begin
      r = @cache.get "list_#{params[:id]}_tags"
    rescue
      r = []
      @tags.each do |tag|
        r << tag.taggable_type.classify.constantize.find_all_by_id(tag.taggable_id).first
      end
      if Rails.env.to_s == "production"
        @cache.set "list_#{params[:id]}_tags", r
      end
      r
    end
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
