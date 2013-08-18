class Api::V1::KeywordsController < Api::V1::BaseController

  inherit_resources

  def search
    keywords = Keyword.where("lower(keyword) LIKE ?", "%" + params[:term].downcase + "%")
    results = []
    keywords.each do |keyword|
      results << { label: keyword.keyword, value: keyword.keyword, id: keyword.id }
    end
    render json: results
  end

end

