class Api::V1::MediaKeywordsController < Api::V1::BaseController

  inherit_resources

  def index
    @media_keywords = MediaKeyword.find(:all, include: [:keyword])
    @keywords = Keyword.find_all_by_id @media_keywords.map(&:keyword_id)
  end

  def create
    respond_to do |format|
      keyword_ids = params[:keyword_ids]
      mediable_id = params[:mediable_id]
      mediable_type = params[:mediable_type]
      temp_user_id = params[:temp_user_id] ? params[:temp_user_id] : 0
      user_id = current_api_user ? current_api_user.id : 0
      keyword_ids.each do |keyword_id|
        media_keyword = MediaKeyword.where(keyword_id: keyword_id, mediable_id: mediable_id, mediable_type: mediable_type)
        if media_keyword.count == 0
          MediaKeyword.create(keyword_id: keyword_id, mediable_id: mediable_id, mediable_type: mediable_type, temp_user_id: temp_user_id, user_id: user_id)
        end
      end
      format.json { render json: { status: "success" } }
    end
  end

  def destroy
    respond_to do |format|
      if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type)
        media_keyword = MediaKeyword.where(mediable_id: params[:mediable_id], mediable_type: params[:mediable_type], keyword_id: params[:keyword_id])
        if media_keyword.destroy_all
          format.json { render json: { status: "success" } }
        else
          format.json { render json: { status: "error" } }
        end
      end
    end
  end

  def update
    respond_to do |format|
      if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type)
        media_keyword = MediaKeyword.where(mediable_id: params[:media_keyword][:mediable_id], mediable_type: params[:media_keyword][:mediable_type], keyword_id: params[:media_keyword][:keyword_id])
        if media_keyword.count > 0
          media_keyword = media_keyword.first
          media_keyword.approved = params[:media_keyword][:approved]
          if media_keyword.save
            keyword = Keyword.find(params[:media_keyword][:keyword_id])
            keyword.approved = true
            keyword.save
            format.json { render json: { status: "success" } }
          else
            format.json { render json: { status: "error" } }
          end
        else
          format.json { render json: { status: "error" } }
        end
      end
    end
  end

end
