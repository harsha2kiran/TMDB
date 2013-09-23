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
      @movie = Movie.where(id: params[:id]).includes(:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases, :images, :videos, :views, :follows, :tags, :movie_languages, :movie_metadatas)
      @movie = @movie.first
      @all = true
    else
      @movies = Movie.where(approved: true)
      @movies = @movies.includes(:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases, :images, :videos, :views, :follows, :tags, :movie_languages, :movie_metadatas)
      @movie = @movies.find_by_id(params[:id])
      @all = false
    end
    add_default_values(@movie)
    load_additional_values(@movie, "show")
    @current_api_user = current_api_user
  end

  def my_movie
    if current_api_user
      @movies = Movie.where("(approved = TRUE) OR (approved = FALSE AND user_id = ?)", current_api_user.id)
    elsif params[:temp_user_id] && !current_api_user
      @movies = Movie.where("(approved = TRUE) OR (approved = FALSE AND temp_user_id = ?)", params[:temp_user_id])
    else
      @movies = Movie.where(approved: true)
    end
    @movies = @movies.includes(:alternative_titles, :casts, :crews, :movie_genres, :movie_keywords, :revenue_countries, :production_companies, :releases, :images, :videos, :views, :follows, :tags, :movie_languages, :movie_metadatas)
    @movie = @movies.where(original_id: params[:movie_id]).last
    @original_movie = @movies.where(id: params[:movie_id]).first
    @all = false
    if @movie.id != @original_movie.id
      add_original_values(@movie, @original_movie)
    else
      @movie.movie_languages.map(&:language_id).to_yaml
      add_default_values(@movie)
    end
    load_additional_values(@movie, "show")
    @current_api_user = current_api_user
    render "my_movie"
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
    # if current_api_user
    #   movies = Movie.where("lower(title) LIKE ? AND (approved = TRUE OR temp_user_id = ? OR user_id = ?)", "%" + params[:term].downcase + "%", params[:temp_user_id], current_api_user.id)
    # else
    #   movies = Movie.where("lower(title) LIKE ? AND (approved = TRUE OR temp_user_id = ?)", "%" + params[:term].downcase + "%", params[:temp_user_id])
    # end

    movies = Movie.where("lower(title) LIKE ?", "%" + params[:term].downcase + "%")

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
      person_ids << @casts.map(&:person_id) if @casts
      person_ids << @crews.map(&:person_id) if @crews
      person_ids << @tags.map(&:person_id) if @tags
      language_ids << @alternative_titles.map(&:language_id) if @alternative_titles
      language_ids << @movie_languages.map(&:language_id) if @movie_languages
      genre_ids << @movie_genres.map(&:genre_id) if @movie_genres
      keyword_ids << @movie_keywords.map(&:keyword_id) if @movie_keywords
      country_ids << @revenue_countries.map(&:country_id) if @revenue_countries
      country_ids << @releases.map(&:country_id) if @releases
      company_ids << @production_companies.map(&:company_id) if @production_companies
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

  def add_original_values(movie, original_movie)
    @movie_metadatas = movie.movie_metadatas.to_a + original_movie.movie_metadatas.to_a
    @images = movie.images.to_a + original_movie.images.to_a
    @videos = movie.videos.to_a + original_movie.videos.to_a
    @movie_genres = movie.movie_genres.to_a + original_movie.movie_genres.to_a
    @casts = movie.casts.to_a + original_movie.casts.to_a
    @crews = movie.crews.to_a + original_movie.crews.to_a
    @movie_keywords = movie.movie_keywords.to_a + original_movie.movie_keywords.to_a
    @alternative_titles = movie.alternative_titles.to_a + original_movie.alternative_titles.to_a
    @movie_languages = movie.movie_languages.to_a + original_movie.movie_languages.to_a
    @tags = movie.tags.to_a + original_movie.tags.to_a
    @releases = movie.releases.to_a + original_movie.releases.to_a
    @production_companies = movie.production_companies.to_a + original_movie.production_companies.to_a
    @revenue_countries = movie.revenue_countries.to_a + original_movie.revenue_countries.to_a
  end

  def add_default_values(movie)
    @movie_metadatas = movie.movie_metadatas.to_a
    @images = movie.images.to_a
    @videos = movie.videos.to_a
    @movie_genres = movie.movie_genres.to_a
    @casts = movie.casts.to_a
    @crews = movie.crews.to_a
    @movie_keywords = movie.movie_keywords.to_a
    @alternative_titles = movie.alternative_titles.to_a
    @movie_languages = movie.movie_languages.to_a
    @tags = movie.tags.to_a
    @releases = movie.releases.to_a
    @production_companies = movie.production_companies.to_a
    @revenue_countries = movie.revenue_countries.to_a
  end
end
