class Api::V1::CrewsController < Api::V1::BaseController

  inherit_resources

  def index
    @crews = Crew.find(:all, include: [:person, :movie])
    @people = Person.find_all_by_id @crews.map(&:person_id)
    @movies = Movie.find_all_by_id @crews.map(&:movie_id)
  end

end
