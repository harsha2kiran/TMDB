class Api::V1::GenresController < Api::V1::BaseController

  inherit_resources

  def index
    @genres = Genre.where(approved: true)
    @genres.each do |genre|
      genre.movies = []
      movies = []
      movie_ids = genre.movie_genres.where(approved: true).limit(3).uniq.map(&:movie_id)
      unless movie_ids == []
        # movie_ids.each do |id|
          movies << Movie.find_all_by_id(movie_ids, :include => [:images])
        # end
      else
        movies = []
      end
      genre.movies = movies.flatten
    end
  end

  def show
    @genre = Genre.where(id: params[:id], approved: true).includes(:follows).first
    @genre.movies = []
    movies = []
    movie_ids = @genre.movie_genres.where(approved: true).uniq.map(&:movie_id)
    unless movie_ids == []
       movies << Movie.find_all_by_id(movie_ids, :include => [:images])
    else
      movies = []
    end
    @genre.movies = movies.flatten
  end

  def search
    genres = Genre.where("approved = TRUE AND lower(genre) LIKE ?", "%" + params[:term].downcase + "%").order("id ASC")
    results = []
    arr = []
    genres.each do |genre|
      unless arr.include?(genre.genre.downcase)
        arr << genre.genre.downcase
        results << { label: genre.genre, value: genre.genre, id: genre.id }
      end
    end
    render json: results
  end

end
