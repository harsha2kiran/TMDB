class Api::V1::MoviesController < Api::V1::BaseController

  inherit_resources

  def index
    if ["admin", "moderator"].include?(current_user.user_type) && params[:moderate]
      @movies = Movie.all
      @all = false
    else
      @movies = Movie.where(approved: true)
      @all = true
    end
  end

  def show
    if ["admin", "moderator"].include?(current_user.user_type) && params[:moderate]
      @movie = Movie.find params[:id]
      @all = false
    else
      @movie = Movie.where(approved: true).find(params[:id])
      @all = true
    end
  end

end
