class ListsController < ApplicationController

  layout "seo"

  def index
    @index_title = "Lists"
    begin
      cached_content = @cache.get "static_lists"
      if cached_content
        @lists = cached_content
      end
    rescue
      @lists = List.where("(list_type = '' OR list_type IS NULL) AND approved = TRUE").includes(:list_items, :user)
      if Rails.env.to_s == "production"
        @cache.set "static_lists", @lists.all
      end
    end
  end

  def galleries
    @index_title = "Galleries"
    begin
      cached_content = @cache.get "static_galleries"
      if cached_content
        @lists = cached_content
      end
    rescue
      @lists = List.where("list_type = 'gallery' AND approved = TRUE").includes(:list_items, :user)
      if Rails.env.to_s == "production"
        @cache.set "static_galleries", @lists.all
      end
    end
    render "index"
  end

  def channels
    @index_title = "Channels"
    begin
      cached_content = @cache.get "static_channels"
      if cached_content
        @lists = cached_content
      end
    rescue
      @lists = List.where("list_type = 'channel' AND approved = TRUE").includes(:list_items, :user)
      if Rails.env.to_s == "production"
        @cache.set "static_channels", @lists.all
      end
    end
    render "index"
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
      @list = List.where(id: params[:id], approved: true).includes(:list_items, :user, :follows)
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
  end

end
