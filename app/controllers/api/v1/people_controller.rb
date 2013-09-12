class Api::V1::PeopleController < Api::V1::BaseController

  inherit_resources

  def index
    if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type) && params[:moderate]
      @people = Person.all
      @all = true
    else
      @people = Person.where(approved: true)
      @all = false
    end
    @people = @people.order("people.approved DESC, people.updated_at DESC").includes(:alternative_names, :casts, :crews, :images, :videos, :views, :follows, :person_social_apps, :tags)
    filter_results
    load_additional_values(@people, "index")
  end

  def my_people
    if current_api_user
      all_items = Person.where("user_id = ? OR temp_user_id = ?", current_api_user.id, params[:temp_user_id])
    else
      all_items = Person.where("temp_user_id = ?", params[:temp_user_id])
    end
    all_items = all_items.order("people.approved DESC, people.updated_at DESC").includes(:alternative_names, :casts, :crews, :images, :videos, :views, :follows, :person_social_apps, :tags)
    @people = all_items
    filter_results
    @all = false
    load_additional_values(@people, "index")
    render "index"
  end

  def show
    if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type) && params[:moderate]
      @people = Person.find(:all, :includes => [:alternative_names, :casts, :crews, :images, :videos, :views, :follows, :person_social_apps, :tags])
      @person = @people.find_by_id params[:id]
      @all = true
    else
      if current_api_user
        @people = Person.where("(approved = TRUE) OR (approved = FALSE AND user_id = ?)", current_api_user)
      elsif params[:temp_user_id] && !current_api_user
        @people = Person.where("(approved = TRUE) OR (approved = FALSE AND temp_user_id = ?)", params[:temp_user_id])
      else
        @people = Person.where(approved: true)
      end
      @people = @people.includes(:alternative_names, :casts, :crews, :images, :videos, :views, :follows, :person_social_apps, :tags)
      @person = @people.last #find_by_id params[:id]
      @all = false
    end

    load_additional_values(@person, "show")
    @current_api_user = current_api_user
  end

  def create
    if params[:edit_page]
      create!
    else
      person = Person.where("lower(name) LIKE ?", "%" + params[:person][:name].downcase + "%")
      if person.count > 0
        raise "error"
      else
        create!
      end
    end
  end

  def search
    people = Person.where("lower(name) LIKE ? AND (approved = TRUE OR temp_user_id = ?)", "%" + params[:term].downcase + "%", params[:temp_user_id])
    results = []
    people.each do |person|
      results << { label: person.name, value: person.name, id: person.id }
    end
    render json: results
  end

  private

  def filter_results
    original_ids = []
    @people.each_with_index do |person, i|
      if original_ids.include?(person.original_id)
        @people[i] = ""
      else
        original_ids << person.original_id
      end
    end
    @people.reject! { |c| c == "" }
  end

  def load_additional_values(items, action)
    movie_ids = []
    social_app_ids = []
    if action == "show"
      items = [items]
    end
    items.reject! { |c| c.nil? }
    items.each do |m|
      movie_ids << m.casts.map(&:movie_id)
      movie_ids << m.crews.map(&:movie_id)
      movie_ids << m.tags.map(&:taggable_id)
      social_app_ids << m.person_social_apps.map(&:social_app_id)
    end
    movie_ids = movie_ids.flatten
    social_app_ids = social_app_ids.flatten
    @movies = movie_ids.count > 0 ? Movie.find_all_by_id(movie_ids) : []
    @social_apps = social_app_ids.count > 0 ? SocialApp.find_all_by_id(social_app_ids) : []
  end

end
