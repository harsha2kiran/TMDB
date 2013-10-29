class MoviesController < ActionController::Base

  layout "seo"

  def index
    @movies = Movie.where("approved = TRUE AND original_id = id")
    @meta_title = "Movie Database"
    @meta_description = ""
    @meta_keywords = ""
  end

  def show
    @movie = Movie.where(approved: true).find(params[:id], :include => [:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases, :images, :videos, :views, :follows, :tags, :movie_languages, :movie_metadatas])
    @meta_title = @movie.meta_title
    @meta_description = @movie.meta_description
    @meta_keywords = @movie.meta_keywords
  end

end
