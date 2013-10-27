object @person
attributes :id, :original_id, :user_id, :approved, :biography, :birthday, :day_of_death, :homepage, :imdb_id, :locked, :name, :place_of_birth, :created_at, :updated_at, :meta_title, :meta_description, :meta_keywords
if @person
  if @all
    node(:alternative_names) { |person| partial("api/v1/alternative_names/index", :object => person.alternative_names) }
    node(:crews) { |person| partial("api/v1/crews/index", :object => person.crews) }
    node(:casts) { |person| partial("api/v1/casts/index", :object => person.casts) }
    node(:person_social_apps) { |person| partial("api/v1/person_social_apps/index", :object => person.person_social_apps) }
    node(:tags) { |person| partial("api/v1/tags/index", :object => person.tags ) }
    node(:images) { |person| person.images }
    node(:videos) { |movie| movie.videos }
  else
    node(:alternative_names) { |person|
      if @current_api_user
        partial("api/v1/alternative_names/index", :object => @alternative_names.select {|s| (s.approved == true || s.user_id == @current_api_user.id) })
      else
        partial("api/v1/alternative_names/index", :object => @alternative_names.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) })
      end
    }
    node(:crews) { |person|
      if @current_api_user
        partial("api/v1/crews/index", :object => @crews.select {|s| (s.approved == true || s.user_id == @current_api_user.id) })
      else
        partial("api/v1/crews/index", :object => @crews.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) })
      end
    }
    node(:casts) { |person|
      if @current_api_user
        partial("api/v1/casts/index", :object => @casts.select {|s| (s.approved == true || s.user_id == @current_api_user.id) })
      else
        partial("api/v1/casts/index", :object => @casts.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) })
      end
    }
    node(:person_social_apps) { |person|
      if @current_api_user
        partial("api/v1/person_social_apps/index", :object => @person_social_apps.select {|s| (s.approved == true || s.user_id == @current_api_user.id) })
      else
        partial("api/v1/person_social_apps/index", :object => @person_social_apps.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) })
      end
    }
    node(:tags) { |person|
      if @current_api_user
        partial("api/v1/tags/index", :object => @tags.select {|s| (s.approved == true || s.user_id == @current_api_user.id) })
      else
        partial("api/v1/tags/index", :object => @tags.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) })
      end
    }
    node(:images) { |person|
      if @current_api_user
        @images.select {|s| (s.approved == true || s.user_id == @current_api_user.id) }
      else
        @images.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) }
      end
    }
    node(:videos) { |person|
      if @current_api_user
        @videos.select {|s| (s.approved == true || s.user_id == @current_api_user.id) }
      else
        @videos.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) }
      end
    }
  end
  node(:follows) { |person|
    if @current_api_user
      person.follows.where(user_id: @current_api_user.id)
    else
      []
    end
  }
  node(:views) { |person| person.views.count }
end
