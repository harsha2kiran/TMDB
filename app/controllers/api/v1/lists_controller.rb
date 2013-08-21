class Api::V1::ListsController < Api::V1::BaseController

  inherit_resources

  def index
    @lists = List.find(:all, :include => [:list_items, :user])
  end

  def show
    @list = List.find_by_id(params[:id], :include => [:list_items, :user])
  end

  def update
    respond_to do |format|
      #TODO remove next line
      current_user = User.first
      list = current_user.lists.find params[:id]
      if list.update_attributes(params[:list])
        format.json { respond_with list }
      else
        format.json { render :json => "Error updating list.", :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      #TODO remove next line
      current_user = User.first
      list = current_user.lists.find params[:id]
      if list.destroy
        format.json { respond_with list }
      else
        format.json { render :json => "Error removing list.", :status => :unprocessable_entity }
      end
    end
  end

  def search_my_lists
    lists = List.where("lower(title) LIKE ? AND user_id = ?", "%" + params[:term].downcase + "%", current_user.id)
    results = []
    lists.each do |list|
      results << { label: list.title, value: list.title, id: list.id }
    end
    render json: results
  end

end
