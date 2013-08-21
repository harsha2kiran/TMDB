class Api::V1::MovieGenresController < Api::V1::BaseController

  inherit_resources

  def index
    @movie_genres = MovieGenre.find(:all, include: [:genre])
    @genres = Genre.find_all_by_id @movie_genres.map(&:genre_id)
  end

end
