class Api::V1::ListsController < Api::V1::BaseController

  inherit_resources

  def index
    @lists = List.where("list_type = ''").includes(:list_items, :user)
  end

  def show
    @list = List.find_by_id(params[:id], :include => [:list_items, :user, :follows])
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
      list = current_api_user.lists.find params[:id]
      if list.destroy
        format.json { respond_with list }
      else
        format.json { render :json => "Error removing list.", :status => :unprocessable_entity }
      end
    end
  end

  def search_my_lists
    lists = List.where("lower(title) LIKE ? AND user_id = ?", "%" + params[:term].downcase + "%", current_api_user.id)
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
