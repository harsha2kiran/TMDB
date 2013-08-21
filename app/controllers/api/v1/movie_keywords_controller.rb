class Api::V1::MovieKeywordsController < Api::V1::BaseController

  inherit_resources

  def index
    @movie_keywords = MovieKeyword.find(:all, include: [:keyword])
    @keywords = Keyword.find_all_by_id @movie_keywords.map(&:keyword_id)
  end

end
