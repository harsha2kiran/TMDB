class Api::V1::ListsController < Api::V1::BaseController

  inherit_resources

  def index
    #TODO remove next line
    current_user = User.first
    @lists = current_user.lists.all
  end

  def show
    #TODO remove next line
    current_user = User.first
    @list = current_user.lists.find params[:id]
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
end
