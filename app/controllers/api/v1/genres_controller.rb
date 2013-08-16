class Api::V1::GenresController < Api::V1::BaseController

  inherit_resources

  def search
    genres = Genre.where("genre LIKE ?", "%" + params[:term].downcase + "%")
    results = []
    genres.each do |genre|
      results << { label: genre.genre, value: genre.genre, id: genre.id }
    end
    render json: results
  end

end
