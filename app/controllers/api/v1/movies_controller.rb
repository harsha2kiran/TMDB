class Api::V1::MoviesController < Api::V1::BaseController

  inherit_resources

  respond_to :json

  def index
    if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type) && params[:moderate]
      all_items = Movie.find(:all, :includes => [:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases])
      @items_count = all_items.count
      @movies = all_items.page(params[:page]).order('title ASC')
      @all = true
    else
      all_items = Movie.where(approved: true).order("movies.approved DESC, movies.updated_at DESC").includes(:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases, :images, :videos, :views, :follows, :tags, :movie_languages, :movie_metadatas)
      @items_count = all_items.count
      @movies = all_items
      filter_results
      @all = false
    end
    load_additional_values(@movies, "index")
  end

  def my_movies
    if current_api_user
      all_items = Movie.where("user_id = ? OR temp_user_id = ?", current_api_user.id, params[:temp_user_id])
    else
      all_items = Movie.where("temp_user_id = ?", params[:temp_user_id])
    end
    all_items = all_items.order("movies.approved DESC, movies.updated_at DESC").includes(:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases, :images, :videos, :views, :follows, :tags, :movie_languages, :movie_metadatas)
    @items_count = all_items.count
    @movies = all_items
    filter_results
    @all = false
    load_additional_values(@movies, "index")
    render "index"
  end

  def create
    if params[:edit_page]
      create!
    else
      movie = Movie.where("lower(title) = ?", params[:movie][:title].downcase)
      if movie.count > 0
        raise "error"
      else
        create!
      end
    end
  end

  def show
    if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type) && params[:moderate]
      @movies = Movie.find(:all, :includes => [:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases, :images, :videos, :views, :follows, :tags, :movie_languages, :movie_metadatas])
      @movie = @movies.find_by_id(params[:id])
      @all = true
    else
      if current_api_user
        @movies = Movie.where("(approved = TRUE) OR (approved = FALSE AND user_id = ?)", current_api_user.id)
      elsif params[:temp_user_id] && !current_api_user
        @movies = Movie.where("(approved = TRUE) OR (approved = FALSE AND temp_user_id = ?)", params[:temp_user_id])
      else
        @movies = Movie.where(approved: true)
      end
      @movies = @movies.includes(:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases, :images, :videos, :views, :follows, :tags, :movie_languages, :movie_metadatas)
      @movie = @movies.where(original_id: params[:id]).last #.last #find_by_id(params[:id])
      @all = false
    end
    load_additional_values(@movie, "show")
    @current_api_user = current_api_user
  end

  def edit_popular
    if current_api_user && current_api_user.user_type == "admin"
      @movies = Movie.select("id, title, popular").where(approved: true).includes(:images).order("popular ASC")
    else
      @movies = []
    end
    render 'popular'
  end

  def get_popular
    @movies = Movie.select("id, title, popular").where("approved = TRUE AND popular != 0 AND popular IS NOT NULL").includes(:images).order("popular ASC")
    render 'popular'
  end

  def search
    movies = Movie.where("lower(title) LIKE ? AND (approved = TRUE || temp_user_id = ?)", "%" + params[:term].downcase + "%", params[:temp_user_id])
    results = []
    movies.each do |movie|
      results << { label: movie.title, value: movie.title, id: movie.id }
    end
    render json: results
  end

  private

  def filter_results
    original_ids = []
    @movies.each_with_index do |movie, i|
      if original_ids.include?(movie.original_id)
        @movies[i] = ""
      else
        original_ids << movie.original_id
      end
    end
    @movies.reject! { |c| c == "" }
  end

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
    items.reject! { |c| c.nil? }
    items.each do |m|
      person_ids << m.casts.map(&:person_id)
      person_ids << m.crews.map(&:person_id)
      person_ids << m.tags.map(&:person_id)
      language_ids << m.alternative_titles.map(&:language_id)
      language_ids << m.movie_languages.map(&:language_id)
      genre_ids << m.movie_genres.map(&:genre_id)
      keyword_ids << m.movie_keywords.map(&:keyword_id)
      country_ids << m.revenue_countries.map(&:country_id)
      country_ids << m.releases.map(&:country_id)
      company_ids << m.production_companies.map(&:company_id)
    end
    person_ids = person_ids.flatten.uniq
    genre_ids = genre_ids.flatten.uniq
    language_ids = language_ids.flatten.uniq
    keyword_ids = keyword_ids.flatten.uniq
    country_ids = country_ids.flatten.uniq
    company_ids = company_ids.flatten.uniq
    @languages = language_ids.count > 0 ? Language.find_all_by_id(language_ids) : []
    @people = person_ids.count > 0 ? Person.find_all_by_id(person_ids) : []
    @genres = genre_ids.count > 0 ? Genre.find_all_by_id(genre_ids) : []
    @keywords = keyword_ids.count > 0 ? Keyword.find_all_by_id(keyword_ids) : []
    @countries = country_ids.count > 0 ? Country.find_all_by_id(country_ids) : []
    @companies = company_ids.count > 0 ? Company.find_all_by_id(company_ids) : []
    @statuses = Status.all
  end

end
