class Api::V1::MoviesController < Api::V1::BaseController

  inherit_resources

  def index
      @movies = Movie.find(:all, :include => [:alternative_titles])

      # @movies.each do |movie|
      #   movie.alternative_titles.each do |alt|
      #     alt.language = alt.language_id
      #   end
      # end

    # @alternative_titles = []
    # @movies.each do |movie|
    #   @alternative_titles = AlternativeTitle.find(movie.alternative_titles.map(&:id))
    # end

  end

end
