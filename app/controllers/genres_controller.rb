class GenresController < ApplicationController

  layout "seo"

  def index
    begin
      @genres = @cache.get "genres"
    rescue
      @genres = Genre.where(approved: true).includes(:movie_genres)
      @genres.each do |genre|
        genre.movies = []
        movies = []
        movie_ids = genre.movie_genres.where(approved: true).limit(3).uniq.map(&:movie_id)
        unless movie_ids == []
            movies << Movie.where(approved: true).find_all_by_id(movie_ids, :include => [:images])
        else
          movies = []
        end
        genre.movies = movies.flatten
      end
      if Rails.env.to_s == "production"
        @cache.set "genres", @genres.all
      end
    end
  end

  def show
    begin
      @genre = @cache.get "genre_show_#{params[:id]}"
    rescue
      @genre = Genre.where(id: params[:id], approved: true).includes(:follows, :movie_genres).first
      if @genre
        @genre.movies = []
        movies = []
        movie_ids = @genre.movie_genres.where(approved: true).uniq.map(&:movie_id)
        unless movie_ids == []
           movies << Movie.where(approved: true).find_all_by_id(movie_ids, :include => [:images])
        else
          movies = []
        end
        @genre.movies = movies.flatten
      end
      if Rails.env.to_s == "production"
        @cache.set "genre_show_#{params[:id]}", @genre
      end
    end
  end

end
