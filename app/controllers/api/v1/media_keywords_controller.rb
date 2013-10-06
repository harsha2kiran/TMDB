class Api::V1::MediaKeywordsController < Api::V1::BaseController

  inherit_resources

  def index
    @media_keywords = MediaKeyword.find(:all, include: [:keyword])
    @keywords = Keyword.find_all_by_id @media_keywords.map(&:keyword_id)
  end

  def create
    keyword_ids = params[:keyword_ids]
    mediable_id = params[:mediable_id]
    mediable_type = params[:mediable_type]
    temp_user_id = params[:temp_user_id] ? params[:temp_user_id] : 0
    user_id = current_api_user ? current_api_user.id : 0
    keyword_ids.each do |keyword_id|
      MediaKeyword.create(keyword_id: keyword_id, mediable_id: mediable_id, mediable_type: mediable_type, temp_user_id: temp_user_id, user_id: user_id)
    end
    render nothing: true
  end

end
