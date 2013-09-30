class Api::V1::PeopleController < Api::V1::BaseController

  inherit_resources

  include PeopleHelper

  def index
    if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type) && params[:moderate]
      all_items = Person.find_all_and_include
      @items_count = all_items.count
      @people = all_items.page(params[:page]).order('name ASC')
      @all = true
    else
      all_items = Person.find_all_approved_includes
      @items_count = all_items.count
      @people = all_items
      @people = filter_results(@people)
      @all = false
    end
    @current_api_user = current_api_user
    load_additional_values(@people, "index")
  end

  def my_people
    if current_api_user
      all_items = Person.all_by_user_or_temp(current_api_user.id, params[:temp_user_id])
    else
      all_items = Person.all_by_temp(params[:temp_user_id])
    end
    all_items = all_items.order_include_my_people
    @people = all_items
    @people = filter_results(@people)
    @all = false
    load_additional_values(@people, "index")
    @current_api_user = current_api_user
    render "my_people"
  end

  def show
    if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type) && params[:moderate]
      @person = Person.find_and_include_by_id(params[:id])
      @person = @person.first
      @original_person = @person
      @all = true
    else
      @people = Person.find_and_include_all_approved
      @person = @people.find_by_id(params[:id])
      @all = false
    end
    add_default_values(@person)
    load_additional_values(@person, "show")
    @current_api_user = current_api_user
  end

  def my_person
    if current_api_user
      @people = Person.my_person_by_user(current_api_user.id)
    elsif params[:temp_user_id] && !current_api_user
      @people = Person.my_person_by_temp(params[:temp_user_id])
    else
      @people = Person.where(approved: true)
    end
    @people = @people.includes(:alternative_names, :casts, :crews, :images, :videos, :views, :follows, :person_social_apps, :tags)
    @person = @people.where(original_id: params[:person_id]).order("updated_at DESC").first
    @original_person = @people.where(id: params[:person_id]).first
    @all = false
    if @person.id != @original_person.id
      add_original_values(@person, @original_person)
    else
      add_default_values(@person)
    end
    load_additional_values(@person, "show")
    @current_api_user = current_api_user
    render "my_person"
  end

  def create
    if params[:edit_page]
      create!
    else
      person = Person.where("lower(name) = ?", params[:person][:name].downcase)
      if person.count > 0
        raise "error"
      else
        create!
      end
    end
  end

  def search
    people = Person.where("lower(name) LIKE ? AND id = original_id", "%" + params[:term].downcase + "%")
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
    items.reject! { |c| c.nil? }
    items.each do |m|
      movie_ids << @casts.map(&:movie_id) if @casts
      movie_ids << @crews.map(&:movie_id) if @crews
      movie_ids << @tags.map(&:taggable_id) if @tags
      social_app_ids << @person_social_apps.map(&:social_app_id) if @person_social_apps
    end
    movie_ids = movie_ids.flatten.uniq
    social_app_ids = social_app_ids.flatten.uniq
    @movies = movie_ids.count > 0 ? Movie.find_all_by_id(movie_ids) : []
    @social_apps = social_app_ids.count > 0 ? SocialApp.find_all_by_id(social_app_ids) : []
  end

  def add_original_values(person, original_person)
    @images = person.images.to_a + original_person.images.to_a
    @videos = person.videos.to_a + original_person.videos.to_a
    @casts = person.casts.to_a + original_person.casts.to_a
    @crews = person.crews.to_a + original_person.crews.to_a
    @tags = person.tags.to_a + original_person.tags.to_a
    @alternative_names = person.alternative_names.to_a + original_person.alternative_names.to_a
    @person_social_apps = person.person_social_apps.to_a + original_person.person_social_apps.to_a
  end

  def add_default_values(person)
    @images = person.images.to_a
    @videos = person.videos.to_a
    @casts = person.casts.to_a
    @crews = person.crews.to_a
    @tags = person.tags.to_a
    @alternative_names = person.alternative_names.to_a
    @person_social_apps = person.person_social_apps.to_a
  end

end
