class Api::V1::BaseController < ApplicationController

  respond_to :json, :js

  before_filter :set_controller_name, :except => [:mark, :unmark]
  before_filter :set_params_user_id, :except => [:mark, :unmark]
  before_filter :set_approved_false, :except => [:mark, :unmark]
  before_filter :check_if_destroy, :except => [:mark, :unmark]
  before_filter :check_if_update, :except => [:mark, :unmark]
  before_filter :fix_temp_user_id
  after_filter :set_pending
  after_filter :clear_cache

  def fix_temp_user_id
    if params[:temp_user_id] == "undefined"
      params[:temp_user_id] = ""
    end
  end

  def clear_cache
    if ["update", "create", "destroy", "mark", "import_all"].include?(params[:action]) && @controller != "views"
      @cache.flush
    end
  end

  def set_pending
    if ["create", "update"].include?(params[:action])

      hash_id = @controller.singularize

      if is_pendable
        if current_api_user
          last_item = @controller.classify.constantize.where(user_id: current_api_user.id).last
        else
          last_item = @controller.classify.constantize.where(temp_user_id: params[hash_id.to_sym][:temp_user_id]).last
        end
      end

      # all these have movie_id column
      if ["alternative_titles", "casts", "crews", "movie_genres",
          "movie_keywords", "movie_languages", "movie_metadatas",
          "production_companies", "releases", "revenue_countries"].include?(@controller)
        pending = add_new_pending_item(hash_id, last_item)
        pending.pendable_id = params[hash_id.to_sym][:movie_id]
        pending.pendable_type = "Movie"
        unless pending_exist(pending, hash_id, last_item)
          pending.save
        end
      end

      # all these have person_id column
      if ["alternative_names", "casts", "crews", "person_social_apps", "tags"].include?(@controller)
        pending = add_new_pending_item(hash_id, last_item)
        pending.pendable_id = params[hash_id.to_sym][:person_id]
        pending.pendable_type = "Person"
        unless pending_exist(pending, hash_id, last_item)
          pending.save
        end
      end

      if @controller == "images" && params[:action] == "update"
        pending = add_new_pending_item(hash_id, last_item)
        pending.pendable_id = params[hash_id.to_sym][:imageable_id]
        pending.pendable_type = params[hash_id.to_sym][:imageable_type]
        unless pending_exist(pending, hash_id, last_item)
          pending.save
        end
      end

      if @controller == "videos"
        pending = add_new_pending_item(hash_id, last_item)
        pending.pendable_id = params[hash_id.to_sym][:videable_id]
        pending.pendable_type = params[hash_id.to_sym][:videable_type]
        unless pending_exist(pending, hash_id, last_item)
          pending.save
        end
      end

      if @controller == "tags"
        pending = add_new_pending_item(hash_id, last_item)
        pending.pendable_id = params[hash_id.to_sym][:taggable_id]
        pending.pendable_type = params[hash_id.to_sym][:taggable_type]
        unless pending_exist(pending, hash_id, last_item)
          pending.save
        end
      end

      if @controller == "movies"
        pending = add_new_pending_item(hash_id, last_item)
        pending.pendable_id = pending.approvable_id
        pending.pendable_type = "Movie"
        unless pending_exist(pending, hash_id, last_item)
          pending.save
        end
      end

      if @controller == "people"
        pending = add_new_pending_item(hash_id, last_item)
        pending.pendable_id = pending.approvable_id
        pending.pendable_type = "Person"
        unless pending_exist(pending, hash_id, last_item)
          pending.save
        end
      end
    end
  end

  def current_api_user
    if doorkeeper_token
      @current_api_user ||= User.find(doorkeeper_token.resource_owner_id)
    else
      current_user
    end
  end

  private

  def is_pendable
    if ["alternative_names", "casts", "crews", "person_social_apps", "tags",
      "images", "videos", "alternative_titles", "casts", "crews", "movie_genres",
      "movie_keywords", "movie_languages", "movie_metadatas", "movies", "people",
      "production_companies", "releases", "revenue_countries"].include?(@controller)
      true
    else
      false
    end
  end

  def pending_exist(pending, hash_id, last_item)
    if current_api_user
      exist = PendingItem.where(
        pendable_id: pending.pendable_id, pendable_type: pending.pendable_type,
        approvable_id: last_item.id, approvable_type: @controller.classify,
        user_id: current_api_user.id)
    else
      exist = PendingItem.where(
        pendable_id: pending.pendable_id, pendable_type: pending.pendable_type,
        approvable_id: last_item.id, approvable_type: @controller.classify,
        temp_user_id: params[hash_id.to_sym][:temp_user_id])
    end
    exist = exist.count > 0 ? true : false
  end

  def add_new_pending_item(hash_id, last_item)
    pending = PendingItem.new
    if current_api_user && current_api_user.id
      pending.user_id = current_api_user.id
    else
      pending.temp_user_id = params[hash_id.to_sym][:temp_user_id]
    end
    if @controller == "movies" || @controller == "people"
      pending.approvable_id = last_item.original_id
    else
      pending.approvable_id = last_item.id
    end
    pending.approvable_type = @controller.classify
    pending
  end

  def set_controller_name
    @controller = params[:controller].gsub("api/v1/", "")
    if @controller != "approvals"
      @attribute_names = @controller.classify.constantize.attribute_names
    else
      @attribute_names = []
    end
  end

  def set_params_user_id
    if ["create", "update"].include?(params[:action])
      #comment this
      if params[:temp_user_id]
        params["#{@controller.singularize.to_sym}"][:temp_user_id] = params[:temp_user_id]
      end
      # add user_id value from current_user or redirect to login.
      # check if current model has attribute user_id, if not, skip it
      if current_api_user && @attribute_names.include?("user_id")
        params["#{@controller.singularize.to_sym}"][:user_id] = current_api_user.id
      end
      #comment this
      if !current_api_user && @attribute_names.include?("temp_user_id") && !params["#{@controller.singularize.to_sym}"][:temp_user_id]
        raise "user_id or temp_user_id must be provided for update or create"
      end
    end
  end

  def set_approved_false
    # add approved = false value to record on create if column exist
    if params[:action] == "create"
      if @attribute_names.include?("approved")
        if current_api_user && current_api_user.user_type == "admin"
          unless params["#{@controller.singularize.to_sym}"][:approved]
            params["#{@controller.singularize.to_sym}"][:approved] = false
          end
        else
          params["#{@controller.singularize.to_sym}"][:approved] = false
        end
      end
    end
  end

  def check_if_destroy
    if params[:action] == "destroy"
      if current_api_user && ["admin", "moderator"].include?(current_api_user.user_type)
      else
        if current_api_user &&
          (
            (@controller == "list_items" && current_api_user.lists.map(&:id).include?(params[:list_item][:list_id].to_i) ) ||
            (@controller == "lists" && current_api_user.lists.map(&:id).include?(params[:id].to_i) ) ||
            (@controller == "follows" &&
             current_api_user.follows.where(followable_id: params[:followable_id].to_i, followable_type: params[:followable_type]).count > 0)
          )

        elsif params[:temp_user_id] &&
          (@controller == "list_items" && ListItem.where(list_id: params[:list_item][:list_id]).map(&:temp_user_id).include?(params[:temp_user_id]))
        else
          redirect_to root_path, alert: "You must have admin privileges to remove record."
        end
      end
    else
    end
  end

  def check_if_update
    if params[:action] == "update"
      if current_api_user
        if ["admin", "moderator"].include?(current_api_user.user_type) || @controller == "images"
        elsif @controller == "users" && params[:id].to_s == current_api_user.id.to_s
        else
          redirect_to root_path, alert: "You must have admin or moderator privileges to update record."
        end
      elsif params[:temp_user_id] && !current_api_user && (@controller == "movies" || @controller == "people")

      end
    else
    end
  end

end
