class Api::V1::PeopleController < Api::V1::BaseController

  inherit_resources

  def index
    if ["admin", "moderator"].include?(current_api_user.user_type) && params[:moderate]
      @people = Person.all
      @all = true
    else
      @people = Person.where(approved: true)
      @all = false
    end

    load_additional_values(@people, "index")

  end

  def show
    if ["admin", "moderator"].include?(current_api_user.user_type) && params[:moderate]
      @people = Person.all
      @person = @people.find_by_id params[:id]
      @all = true
    else
      @people = Person.where(approved: true)
      @person = @people.find_by_id(params[:id])
      @all = false
    end

    load_additional_values(@person, "show")

  end

  def search
    people = Person.where("lower(name) LIKE ? AND approved = TRUE", "%" + params[:term].downcase + "%")
    results = []
    people.each do |person|
      results << { label: person.name, value: person.name, id: person.id }
    end
    render json: results
  end

  private

  def load_additional_values(items, action)
    movie_ids = []
    social_app_ids = []
    if action == "show"
      items = [items]
    end
    items.each do |m|
      movie_ids << m.casts.map(&:movie_id)
      movie_ids << m.crews.map(&:movie_id)
      social_app_ids << m.person_social_apps.map(&:social_app_id)
    end
    movie_ids = movie_ids.flatten
    social_app_ids = social_app_ids.flatten
    @movies = movie_ids.count > 0 ? Movie.find_all_by_id(movie_ids) : []
    @social_apps = social_app_ids.count > 0 ? SocialApp.find_all_by_id(social_app_ids) : []
  end
end
