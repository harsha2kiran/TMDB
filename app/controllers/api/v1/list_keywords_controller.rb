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
      user_id = current_api_user ? current_api_user.id : "-1"
      list_keyword = ListKeyword.where(
        "(listable_id = ? AND listable_type = ? AND keyword_id = ?) AND (user_id = ? OR temp_user_id = ?)",
        params[:listable_id], params[:listable_type], params[:keyword_id], user_id, params[:temp_user_id])
      if list_keyword.destroy_all
        format.json { render json: { status: "success" } }
      else
        format.json { render json: { status: "error" } }
      end
    end
  end

  def update
    respond_to do |format|
      if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type)
        list_keyword = ListKeyword.where(listable_id: params[:list_keyword][:listable_id], listable_type: params[:list_keyword][:listable_type], keyword_id: params[:list_keyword][:keyword_id])
        if list_keyword.count > 0
          list_keyword = list_keyword.first
          list_keyword.approved = params[:list_keyword][:approved]
          if list_keyword.save
            keyword = Keyword.find(params[:list_keyword][:keyword_id])
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
