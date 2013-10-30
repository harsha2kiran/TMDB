class MoviesController < ApplicationController

  layout "seo"

  def index
    begin
      cached_content = @cache.get "static_movies"
      if cached_content
        @movies = cached_content
      end
    rescue
      @movies = Movie.where("approved = TRUE AND original_id = id")
      if Rails.env.to_s == "production"
        @cache.set "static_movies", @movies.all
      end
    end
    @meta_title = "Movie Database"
    @meta_description = ""
    @meta_keywords = ""
  end

  def show
    begin
      @movie = @cache.get "static_movie_#{params[:id]}"
      @meta_title = @cache.get "static_movie_meta_title_#{params[:id]}"
      @meta_description = @cache.get "static_movie_meta_description_#{params[:id]}"
      @meta_keywords = @cache.get "static_movie_meta_keywords_#{params[:id]}"
    rescue
      @movie = Movie.where(approved: true).find(params[:id], :include => [:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases, :images, :videos, :views, :follows, :tags, :movie_languages, :movie_metadatas])
      @meta_title = @movie.meta_title
      @meta_description = @movie.meta_description
      @meta_keywords = @movie.meta_keywords
      if Rails.env.to_s == "production"
         @cache.set "static_movie_#{params[:id]}", @movie
         @cache.set "static_movie_meta_title_#{params[:id]}", @meta_title
         @cache.set "static_movie_meta_description_#{params[:id]}", @meta_description
         @cache.set "static_movie_meta_keywords_#{params[:id]}", @meta_keywords
      end
    end
  end

end
