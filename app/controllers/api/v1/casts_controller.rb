class Api::V1::CastsController < Api::V1::BaseController

  inherit_resources

  def index
    @casts = Cast.find(:all, include: [:person, :movie])
    @people = Person.find_all_by_id @casts.map(&:person_id)
    @movies = Movie.find_all_by_id @casts.map(&:movie_id)
  end

end
