class Api::V1::MoviesController < Api::V1::BaseController

  inherit_resources

  respond_to :json


  def version

    respond_to do |format|
      versions_list = ["1.2", "1.3", "1.4"]
      ios_versions_list = ["4", "5", "6"]

      version_number = params[:version_number]
      ios_version = params[:ios_version]

      message = "version not found"
      message_type = "alert"
      flag = false

      if versions_list.include?(version_number)
        message = "version found"
        message_type = "web"
        flag = true
      end

      format.json { render :json => { message: message, message_type: message_type, flag: flag } }

    end
  end


  def index
    if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type) && params[:moderate]
      all_items = Movie.find(:all, :includes => [:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases])
      @items_count = all_items.count
      @movies = all_items.page(params[:page]).order('title ASC')
      @all = true
    else
      all_items = Movie.where(approved: true).includes(:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases)
      @items_count = all_items.count
      @movies = all_items.page(params[:page]).order(:title).page(params[:page])
      @all = false
    end

    load_additional_values(@movies, "index")

  end

  def show
    if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type) && params[:moderate]
      @movies = Movie.find(:all, :includes => [:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases])
      @movie = @movies.find_by_id(params[:id])
      @all = true
    else
      @movies = Movie.where(approved: true).includes(:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases)
      @movie = @movies.find_by_id(params[:id])
      @all = false
    end
    load_additional_values(@movie, "show")

  end

  def edit_popular
    if current_api_user && current_api_user.user_type == "admin"
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

  def search
    movies = Movie.where("lower(title) LIKE ? AND approved = TRUE", "%" + params[:term].downcase + "%")
    results = []
    movies.each do |movie|
      results << { label: movie.title, value: movie.title, id: movie.id }
    end
    render json: results
  end

  private

  def load_additional_values(items, action)
    person_ids = []
    language_ids =[]
    genre_ids = []
    keyword_ids = []
    country_ids = []
    company_ids = []
    if action == "show"
      items = [items]
    end
    items.each do |m|
      person_ids << m.casts.map(&:person_id)
      person_ids << m.crews.map(&:person_id)
      person_ids << m.tags.map(&:person_id)
      language_ids << m.alternative_titles.map(&:language_id)
      genre_ids << m.movie_genres.map(&:genre_id)
      keyword_ids << m.movie_keywords.map(&:keyword_id)
      country_ids << m.revenue_countries.map(&:country_id)
      country_ids << m.releases.map(&:country_id)
      company_ids << m.production_companies.map(&:company_id)
    end
    person_ids = person_ids.flatten
    genre_ids = genre_ids.flatten
    language_ids = language_ids.flatten
    keyword_ids = keyword_ids.flatten
    country_ids = country_ids.flatten
    company_ids = company_ids.flatten
    @languages = language_ids.count > 0 ? Language.find(language_ids) : []
    @people = person_ids.count > 0 ? Person.find(person_ids) : []
    @genres = genre_ids.count > 0 ? Genre.find(genre_ids) : []
    @keywords = keyword_ids.count > 0 ? Keyword.find(keyword_ids) : []
    @countries = country_ids.count > 0 ? Country.find(country_ids) : []
    @companies = company_ids.count > 0 ? Company.find(company_ids) : []
  end

end
