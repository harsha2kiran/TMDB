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
    @image = Image.where(approved: true).find(params[:id])
    @movies = Movie.find_all_by_id @image.tags.map(&:taggable_id)
    @people = Person.find_all_by_id @image.tags.map(&:person_id)
  end


end
