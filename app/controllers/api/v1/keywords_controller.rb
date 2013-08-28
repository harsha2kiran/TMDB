class Api::V1::KeywordsController < Api::V1::BaseController

  inherit_resources

  def search
    keywords = Keyword.where("approved = TRUE AND lower(keyword) LIKE ?", "%" + params[:term].downcase + "%").order("id ASC")
    results = []
    arr = []
    keywords.each do |keyword|
      unless arr.include?(keyword.keyword.downcase)
        arr << keyword.keyword.downcase
        results << { label: keyword.keyword, value: keyword.keyword, id: keyword.id }
      end
    end
    render json: results
  end

end

