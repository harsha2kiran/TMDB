class Api::V1::LanguagesController < Api::V1::BaseController

  inherit_resources

  def search
    languages = Language.where("approved = TRUE AND lower(language) LIKE ?", "%" + params[:term].downcase + "%").order("id ASC")
    results = []
    arr = []
    languages.each do |language|
      unless arr.include?(language.language.downcase)
        arr << language.language.downcase
        results << { label: language.language, value: language.language, id: language.id }
      end
    end
    render json: results
  end

end
