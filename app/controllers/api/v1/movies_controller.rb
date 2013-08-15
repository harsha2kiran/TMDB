class Api::V1::MoviesController < Api::V1::BaseController

  inherit_resources

  respond_to :json

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

  def edit_popular
    if current_user.user_type == "admin"
      @movies = Movie.select("id, title, popular").where(approved: true).includes(:images).order("popular DESC")
    else
      @movies = []
    end
    render 'popular'
  end

  def get_popular
    @movies = Movie.select("id, title, popular").where("approved = TRUE AND popular != 0 AND popular IS NOT NULL").includes(:images).order("popular DESC")
    render 'popular'
  end

end
