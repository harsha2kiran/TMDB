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

  def related_images
    if params[:image_id] && params[:image_id] != "0"
      @related_images = find_related_by_image_id(params[:image_id])
    elsif params[:image_ids]
      @related_images = find_related_by_image_ids(params[:image_ids])
    end
    if @related_images
      @related_images = @related_images.uniq
    else
      @related_images = []
    end
  end

  private

  def find_related_by_image_id(image_id)
    image = Image.find image_id
    keyword_ids = image.media_keywords.map(&:keyword_id)
    related_images = []
    media_keywords = MediaKeyword.all
    media_keywords.each do |mk|
      if keyword_ids.include?(mk.keyword_id) && mk.mediable_id != image.id && mk.mediable_type == "Image" && mk.mediable.approved == true
        related_images.push mk.mediable
      end
    end
    related_images
  end

  def find_related_by_image_ids(image_ids)
    related_images = []
    keyword_ids = []
    images = Image.find(eval(image_ids))
    images.each do |image|
      keyword_ids << image.media_keywords.map(&:keyword_id)
    end
    keyword_ids.flatten!
    keyword_ids.uniq!
    media_keywords = MediaKeyword.all
    media_keywords.each do |mk|
      if keyword_ids.include?(mk.keyword_id) && !images.map(&:id).include?(mk.mediable_id) && mk.mediable_type == "Image" && mk.mediable.approved == true
        related_images.push mk.mediable
      end
    end
    related_images
  end

end
