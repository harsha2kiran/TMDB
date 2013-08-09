class Api::V1::FollowsController < Api::V1::BaseController

  inherit_resources

  def index
    #TODO remove next line
    current_user = User.first
    @follows = current_user.follows.all
  end

  def show
    #TODO remove next line
    current_user = User.first
    @follow = current_user.follows.find params[:id]
  end

  def update
    respond_to do |format|
      #TODO remove next line
      current_user = User.first
      follow = current_user.follows.find params[:id]
      if follow.update_attributes(params[:follow])
        format.json { respond_with follow }
      else
        format.json { render :json => "Error updating follow.", :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      #TODO remove next line
      current_user = User.first
      follow = current_user.follows.find params[:id]
      if follow.destroy
        format.json { respond_with follow }
      else
        format.json { render :json => "Error removing follow.", :status => :unprocessable_entity }
      end
    end
  end

end
