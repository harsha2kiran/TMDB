class Api::V1::ListKeywordsController < Api::V1::BaseController

  inherit_resources

  def index
    @list_keywords = ListKeyword.find(:all, include: [:keyword])
    @keywords = Keyword.find_all_by_id @list_keywords.map(&:keyword_id)
  end

  def create
    respond_to do |format|
      keyword_ids = params[:keyword_ids]
      listable_id = params[:listable_id]
      listable_type = params[:listable_type]
      temp_user_id = params[:temp_user_id] ? params[:temp_user_id] : 0
      user_id = current_api_user ? current_api_user.id : 0
      keyword_ids.each do |keyword_id|
        list_keyword = ListKeyword.where(keyword_id: keyword_id, listable_id: listable_id, listable_type: listable_type)
        if list_keyword.count == 0
          ListKeyword.create(keyword_id: keyword_id, listable_id: listable_id, listable_type: listable_type, temp_user_id: temp_user_id, user_id: user_id)
        end
      end
      format.json { render json: { status: "success" } }
    end
  end

  def destroy
    respond_to do |format|
      if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type)
        list_keyword = ListKeyword.where(listable_id: params[:listable_id], listable_type: params[:listable_type], keyword_id: params[:keyword_id])
        if list_keyword.destroy_all
          format.json { render json: { status: "success" } }
        else
          format.json { render json: { status: "error" } }
        end
      end
    end
  end

end
