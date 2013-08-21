class Api::V1::FollowsController < Api::V1::BaseController

  inherit_resources

  def index
    @follows = current_api_user.follows.all
  end

  def show
    @follow = current_api_user.follows.find params[:id]
  end

  def update
    respond_to do |format|
      follow = current_api_user.follows.find params[:id]
      if follow.update_attributes(params[:follow])
        format.json { respond_with follow }
      else
        format.json { render :json => "Error updating follow.", :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      follow = current_api_user.follows.find params[:id]
      if follow.destroy
        format.json { respond_with follow }
      else
        format.json { render :json => "Error removing follow.", :status => :unprocessable_entity }
      end
    end
  end

  def filter
    @follows = current_api_user.follows.where(followable_type: params[:filter]).all
    render 'index'
  end

end
