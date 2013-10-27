class MoviesController < ActionController::Base

  layout "seo"

  def index
    @movies = Movie.where("approved = TRUE AND original_id = id")
    @meta_title = "Movie Database"
    @meta_description = ""
    @meta_keywords = ""
  end

  def show
    @movie = Movie.where(approved: true).find(params[:id])
    @meta_title = @movie.meta_title
    @meta_description = @movie.meta_description
    @meta_keywords = @movie.meta_keywords
  end

end
