class Api::V1::MovieLanguagesController < Api::V1::BaseController

  inherit_resources

  def index
    @movie_languages = MovieLanguage.find(:all, include: [:language])
    @languages = Language.find_all_by_id @movie_languages.map(&:language_id)
  end

end
