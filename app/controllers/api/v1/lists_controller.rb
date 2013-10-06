class Api::V1::ListsController < Api::V1::BaseController

  inherit_resources

  def index
    @lists = List.where("list_type = '' OR list_type IS NULL").includes(:list_items, :user)
    @current_api_user = current_api_user
  end

  def show
    @list = List.find_by_id(params[:id], :include => [:list_items, :user, :follows])
    image_ids = @list.list_items.where(listable_type: "Image").map(&:listable_id)
    @images = Image.find_all_by_id(image_ids)
    @keywords = ListKeyword.where(listable_id: @list.id, listable_type: @list.list_type)
    @tags = ListTag.where(listable_id: @list.id, listable_type: @list.list_type)
    @current_api_user = current_api_user
  end

  def update
    respond_to do |format|
      list = current_api_user.lists.find params[:id]
      if list.update_attributes(params[:list])
        format.json { respond_with list }
      else
        format.json { render :json => "Error updating list.", :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if ["admin", "moderator"].include?(current_api_user.user_type)
        list = List.find(params[:id])
      else
        list = current_api_user.lists.find params[:id]
      end
      if list.destroy
        format.json { respond_with list }
      else
        format.json { render :json => "Error removing list.", :status => :unprocessable_entity }
      end
    end
  end

  def search_my_lists
    lists = List.where("(list_type = '' OR list_type IS NULL) AND lower(title) LIKE ? AND user_id = ?", "%" + params[:term].downcase + "%", current_api_user.id)
    results = []
    lists.each do |list|
      results << { label: list.title, value: list.title, id: list.id }
    end
    render json: results
  end

  def galleries
    @lists = List.where(list_type: "gallery").includes(:list_items, :user)
    render 'index'
  end

  def channels
    @lists = List.where(list_type: "channel").includes(:list_items, :user)
    render 'index'
  end

end
