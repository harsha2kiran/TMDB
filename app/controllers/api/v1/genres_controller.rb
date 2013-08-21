class Api::V1::GenresController < Api::V1::BaseController

  inherit_resources

  def index
    @genres = Genre.all
    @genres.each do |genre|
      genre.movies = []
      movies = []
      movie_ids = genre.movie_genres.where(approved: true).limit(3).uniq.map(&:movie_id)
      unless movie_ids == []
        # movie_ids.each do |id|
          movies << Movie.find(movie_ids, :include => [:images])
        # end
      else
        movies = []
      end
      genre.movies = movies.flatten
    end
  end

  def show
    @genre = Genre.find params[:id]
    @genre.movies = []
    movies = []
    movie_ids = @genre.movie_genres.where(approved: true).uniq.map(&:movie_id)
    unless movie_ids == []
       movies << Movie.find(movie_ids, :include => [:images])
    else
      movies = []
    end
    @genre.movies = movies.flatten
  end

  def search
    genres = Genre.where("lower(genre) LIKE ?", "%" + params[:term].downcase + "%")
    results = []
    genres.each do |genre|
      results << { label: genre.genre, value: genre.genre, id: genre.id }
    end
    render json: results
  end

end
