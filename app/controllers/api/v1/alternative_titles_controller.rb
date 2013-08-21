class Api::V1::AlternativeTitlesController < Api::V1::BaseController

  inherit_resources

  def index
    @alternative_titles = AlternativeTitle.find(:all, include: [:language])
    @languages = Language.find_all_by_id @alternative_titles.map(&:language_id)
  end

end
