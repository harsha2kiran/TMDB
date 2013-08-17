class Api::V1::LanguagesController < Api::V1::BaseController

  inherit_resources

  def search
    languages = Language.where("language LIKE ?", "%" + params[:term].downcase + "%")
    results = []
    languages.each do |language|
      results << { label: language.language, value: language.language, id: language.id }
    end
    render json: results
  end

end
