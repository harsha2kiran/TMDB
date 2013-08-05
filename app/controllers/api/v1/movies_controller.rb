class Api::V1::MoviesController < Api::V1::BaseController
  inherit_resources
  def index
    @movies = Movie.all
    render "index"
  end
end
