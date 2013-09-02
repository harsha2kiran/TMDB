class Api::V1::FollowsController < Api::V1::BaseController

  inherit_resources

  def index
    @follows = current_api_user.follows.all
    movie_ids = []
    person_ids = []
    list_ids = []
    @follows.each do |m|
      if m.followable_type == "Movie"
        movie_ids << m.followable_id
      elsif m.followable_type == "Person"
        person_ids << m.followable_id
      elsif m.followable_type == "List"
        list_ids << m.followable_id
      end
    end
    movie_ids = movie_ids.flatten
    person_ids = person_ids.flatten
    list_ids = list_ids.flatten
    @movies = movie_ids.count > 0 ? Movie.find_all_by_id(movie_ids) : []
    @people = person_ids.count > 0 ? Person.find_all_by_id(person_ids) : []
    @lists = list_ids.count > 0 ? List.find_all_by_id(list_ids) : []
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
      if params[:followable_id] && params[:followable_type]
        follow = current_api_user.follows.where(followable_id: params[:followable_id], followable_type: params[:followable_type])
      else
        follow = current_api_user.follows.where(id: params[:id])
      end
      if follow.destroy_all
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
