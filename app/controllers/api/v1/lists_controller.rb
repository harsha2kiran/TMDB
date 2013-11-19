class Api::V1::ListsController < Api::V1::BaseController

  inherit_resources

  def index
    page = params[:page] ? params[:page] : 1
    begin
      cached_content = @cache.get "lists?page=#{page}"
      if cached_content
        @lists = cached_content
      end
    rescue
      if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type)
        @lists = List.where("list_type = '' OR list_type IS NULL").includes(:list_items, :user)
      elsif current_api_user && current_api_user.user_type == "user"
        @lists = List.where("(list_type = '' OR list_type IS NULL) AND (approved = true OR user_id = ?)", current_api_user.id).includes(:list_items, :user)
      elsif params[:temp_user_id] && params[:temp_user_id] != "undefined"
        @lists = List.where("(list_type = '' OR list_type IS NULL) AND (approved = true OR temp_user_id = ?)", params[:temp_user_id]).includes(:list_items, :user)
      else
        @lists = List.where("list_type = '' OR list_type IS NULL AND approved = true").includes(:list_items, :user, :follows)
      end
      @lists = @lists.page(page).per(20)
      if Rails.env.to_s == "production"
        @cache.set "lists?page=#{page}", @lists.all
      end
    end
    @current_api_user = current_api_user
  end

  def show
    begin
      @list = @cache.get "list/#{params[:id]}"
      @movies = @cache.get "list/#{params[:id]}/movies"
      @people = @cache.get "list/#{params[:id]}/people"
      @images = @cache.get "list/#{params[:id]}/images"
      @videos = @cache.get "list/#{params[:id]}/videos"
      @keywords = @cache.get "list/#{params[:id]}/keywords"
      @tags =  @cache.get "list/#{params[:id]}/tags"
    rescue
      if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type)
        @list = List.where(id: params[:id]).includes(:list_items, :user, :follows)
      elsif current_api_user && current_api_user.user_type == "user"
        @list = List.where("id = ? AND (approved = true OR user_id = ?)", params[:id], current_api_user.id).includes(:list_items, :user, :follows)
      elsif params[:temp_user_id] && params[:temp_user_id] != "undefined"
        @list = List.where("id = ? AND (approved = true OR temp_user_id = ?)", params[:id], params[:temp_user_id]).includes(:list_items, :user, :follows)
      else
        @list = List.where(id: params[:id], approved: true).includes(:list_items, :user, :follows)
      end
      @list = @list.first
      if @list
        movie_ids = @list.list_items.where(listable_type: "Movie").map(&:listable_id)
        person_ids = @list.list_items.where(listable_type: "Person").map(&:listable_id)
        image_ids = @list.list_items.where(listable_type: "Image").map(&:listable_id)
        video_ids = @list.list_items.where(listable_type: "Video").map(&:listable_id)

        @movies = Movie.where("id IN (?)", movie_ids)
        @people = Person.where("id IN (?)", person_ids)

        movie_image_ids = Image.where("imageable_id IN (?) AND imageable_type = 'Movie'", movie_ids).map(&:id)
        person_image_ids = Image.where("imageable_id IN (?) AND imageable_type = 'Person'", person_ids).map(&:id)
        image_ids = image_ids + movie_image_ids + person_image_ids

        @images = Image.where("id IN (?)", image_ids).order("priority ASC")
        @videos = Video.where("id IN (?)", video_ids).order("priority ASC")
        @keywords = ListKeyword.where(listable_id: @list.id, listable_type: @list.list_type)
        @tags = ListTag.where(listable_id: @list.id, listable_type: @list.list_type)
      else
        @movies = []
        @people = []
        @images = []
        @videos = []
        @keywords = []
        @tags = []
      end
      if Rails.env.to_s == "production"
        @cache.set "list/#{params[:id]}", @list
        @cache.set "list/#{params[:id]}/movies", @movies
        @cache.set "list/#{params[:id]}/people", @people
        @cache.set "list/#{params[:id]}/images", @images
        @cache.set "list/#{params[:id]}/videos", @videos
        @cache.set "list/#{params[:id]}/keywords", @keywords
        @cache.set "list/#{params[:id]}/tags", @tags
      end
    end
    @current_api_user = current_api_user
  end

  def update
    respond_to do |format|
      list = current_api_user.lists.find params[:id]
      if list.update_attributes(params[:list])
        format.json { respond_with list }
      else
        format.json { render :json => "Error updating list.", :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if ["admin", "moderator"].include?(current_api_user.user_type)
        list = List.find(params[:id])
      else
        list = current_api_user.lists.find params[:id]
      end
      if list.destroy
        format.json { respond_with list }
      else
        format.json { render :json => "Error removing list.", :status => :unprocessable_entity }
      end
    end
  end

  def search_my_lists
    lists = List.where("(list_type = '' OR list_type IS NULL) AND lower(title) LIKE ? AND user_id = ?", "%" + params[:term].downcase + "%", current_api_user.id)
    results = []
    lists.each do |list|
      results << { label: list.title, value: list.title, id: list.id }
    end
    render json: results
  end

  def galleries
    page = params[:page] ? params[:page] : 1
    begin
      cached_content = @cache.get "galleries?page=#{page}"
      if cached_content
        @lists = cached_content
      end
    rescue
      if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type)
        @lists = List.where(list_type: "gallery").includes(:list_items, :user)
      elsif current_api_user && current_api_user.user_type == "user"
        @lists = List.where("(list_type = 'gallery') AND (approved = true OR user_id = ?)", current_api_user.id).includes(:list_items, :user)
      elsif params[:temp_user_id] && params[:temp_user_id] != "undefined"
        @lists = List.where("(list_type = 'gallery') AND (approved = true OR temp_user_id = ?)", params[:temp_user_id]).includes(:list_items, :user)
      else
        @lists = List.where(list_type: "gallery", approved: true).includes(:list_items, :user, :follows)
      end
      @lists = @lists.page(page).per(20)
      if Rails.env.to_s == "production"
        @cache.set "galleries?page=#{page}", @lists.all
      end
    end
    @image_ids = @lists.map(&:list_items).flatten.map(&:listable_id)
    @images = Image.find_all_by_id(@image_ids)
    @current_api_user = current_api_user
    render 'index'
  end

  def channels
    page = params[:page] ? params[:page] : 1
    begin
      cached_content = @cache.get "channels?page=#{page}"
      if cached_content
        @lists = cached_content
      end
    rescue
      if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type)
        @lists = List.where(list_type: "channel").includes(:list_items, :user)
      elsif current_api_user && current_api_user.user_type == "user"
        @lists = List.where("(list_type = 'channel') AND (approved = true OR user_id = ?)", current_api_user.id).includes(:list_items, :user)
      elsif params[:temp_user_id] && params[:temp_user_id] != "undefined"
        @lists = List.where("(list_type = 'channel') AND (approved = true OR temp_user_id = ?)", params[:temp_user_id]).includes(:list_items, :user)
      else
        @lists = List.where(list_type: "channel", approved: true).includes(:list_items, :user, :follows)
      end
      @lists = @lists.page(page).per(20)
      if Rails.env.to_s == "production"
        @cache.set "channels?page=#{page}", @lists.all
      end
    end
    @image_ids = @lists.map(&:list_items).flatten.map(&:listable_id)
    @images = Image.find_all_by_id(@image_ids)
    @current_api_user = current_api_user
    render 'index'
  end

end
