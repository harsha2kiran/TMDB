class Api::V1::ImagesController < Api::V1::BaseController

  inherit_resources

  def index
    @images = Image.where(approved: true).includes(:taggable)
    movie_ids = []
    @images.each do |image|
      movie_ids << image.map(&:taggable_id)
    end
    movie_ids = movie_ids.flatten
    @movies = Movie.find_all_by_id movie_ids
    @people = Person.find_all_by_id @images.tags.map(&:person_id)
  end

  def show
    @image = Image.find_all_by_id(params[:id])
    if @image != []
      @image = @image.first
      @media_tags = @image.media_tags
      @media_keywords = @image.media_keywords
      if current_api_user
        @current_api_user = current_api_user
      end
    end
  end

  def create
    @image = Image.new params["image"]
    if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type)
      @image.approved = true
    end
    create!
  end

end
