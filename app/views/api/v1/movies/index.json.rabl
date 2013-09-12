object @movies
attributes :id, :original_id, :user_id, :approved, :content_score, :locked, :overview, :tagline, :title, :created_at, :updated_at

if @all
  node(:images) { |movie| movie.images }
  node(:videos) { |movie| movie.videos.link_active == true }

  node(:alternative_titles) { |movie| partial("api/v1/alternative_titles/index", :object => movie.alternative_titles ) }
  node(:crews) { |movie| partial("api/v1/crews/index", :object => movie.crews) }
  node(:casts) { |movie| partial("api/v1/casts/index", :object => movie.casts) }
  node(:movie_genres) { |movie| partial("api/v1/movie_genres/index", :object => movie.movie_genres) }
  node(:movie_keywords) { |movie| partial("api/v1/movie_keywords/index", :object => movie.movie_keywords) }
  node(:movie_languages) { |movie| partial("api/v1/movie_languages/index", :object => movie.movie_languages) }
  node(:movie_metadatas) { |movie| partial("api/v1/movie_metadatas/index", :object => movie.movie_metadatas) }
  node(:revenue_countries) { |movie| partial("api/v1/revenue_countries/index", :object => movie.revenue_countries) }
  node(:tags) { |movie| partial("api/v1/tags/index", :object => movie.tags ) }
  node(:production_companies) { |movie| partial("api/v1/production_companies/index", :object => movie.production_companies ) }
  node(:releases) { |movie| partial("api/v1/releases/index", :object => movie.releases ) }

else

  node(:images) { |movie|
    if @current_api_user
      movie.images.order("images.priority ASC").select {|s| (s.approved == true || s.user_id == @current_api_user.id) }
    else
      movie.images.order("images.priority ASC").select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) }
    end
  }
  node(:videos) { |movie|
    if @current_api_user
      movie.videos.order("videos.priority ASC").select {|s| ((s.approved == true || s.user_id == @current_api_user.id) && s.link_active == true) }
    else
      movie.videos.order("videos.priority ASC").select {|s| ((s.approved == true || s.temp_user_id == params[:temp_user_id]) && s.link_active == true) }
    end
  }
  node(:alternative_titles) { |movie|
    if @current_api_user
      partial("api/v1/alternative_titles/index", :object => movie.alternative_titles.select {|s| (s.approved == true || s.user_id == @current_api_user.id) } )
    else
      partial("api/v1/alternative_titles/index", :object => movie.alternative_titles.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) } )
    end
  }
  node(:crews) { |movie|
    if @current_api_user
      partial("api/v1/crews/index", :object => movie.crews.select {|s| (s.approved == true || s.user_id == @current_api_user.id) })
    else
      partial("api/v1/crews/index", :object => movie.crews.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) })
    end
  }
  node(:casts) { |movie|
    if @current_api_user
      partial("api/v1/casts/index", :object => movie.casts.select {|s| (s.approved == true || s.user_id == @current_api_user.id) })
    else
      partial("api/v1/casts/index", :object => movie.casts.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) })
    end
  }
  node(:movie_genres) { |movie|
    if @current_api_user
      partial("api/v1/movie_genres/index", :object => movie.movie_genres.select {|s| (s.approved == true || s.user_id == @current_api_user.id) })
    else
      partial("api/v1/movie_genres/index", :object => movie.movie_genres.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) })
    end
  }
  node(:movie_keywords) { |movie|
    if @current_api_user
      partial("api/v1/movie_keywords/index", :object => movie.movie_keywords.select {|s| (s.approved == true || s.user_id == @current_api_user.id) })
    else
      partial("api/v1/movie_keywords/index", :object => movie.movie_keywords.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) })
    end
  }
  node(:movie_languages) { |movie|
    if @current_api_user
      partial("api/v1/movie_languages/index", :object => movie.movie_languages.select {|s| (s.approved == true || s.user_id == @current_api_user.id) })
    else
      partial("api/v1/movie_languages/index", :object => movie.movie_languages.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) })
    end
  }
  node(:movie_metadatas) { |movie|
    if @current_api_user
      partial("api/v1/movie_metadatas/index", :object => movie.movie_metadatas.select {|s| (s.approved == true || s.user_id == @current_api_user.id) })
    else
      partial("api/v1/movie_metadatas/index", :object => movie.movie_metadatas.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) })
    end
  }
  node(:revenue_countries) { |movie|
    if @current_api_user
      partial("api/v1/revenue_countries/index", :object => movie.revenue_countries.select {|s| (s.approved == true || s.user_id == @current_api_user.id) })
    else
      partial("api/v1/revenue_countries/index", :object => movie.revenue_countries.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) })
    end
  }
  node(:tags) { |movie|
    if @current_api_user
      partial("api/v1/tags/index", :object => movie.tags.select {|s| (s.approved == true || s.user_id == @current_api_user.id) } )
    else
      partial("api/v1/tags/index", :object => movie.tags.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) } )
    end
  }
  node(:production_companies) { |movie|
    if @current_api_user
      partial("api/v1/production_companies/index", :object => movie.production_companies.select {|s| (s.approved == true || s.user_id == @current_api_user.id) } )
    else
      partial("api/v1/production_companies/index", :object => movie.production_companies.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) } )
    end
  }
  node(:releases) { |movie|
    if @current_api_user
      partial("api/v1/releases/index", :object => movie.releases.select {|s| (s.approved == true || s.user_id == @current_api_user.id) } )
    else
      partial("api/v1/releases/index", :object => movie.releases.select {|s| (s.approved == true || s.temp_user_id == params[:temp_user_id]) } )
    end
  }

end

node(:follows) { |movie| movie.follows }
node(:views) { |movie| movie.views }
