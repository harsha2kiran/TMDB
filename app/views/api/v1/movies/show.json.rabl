object @movie
attributes :id, :original_id, :user_id, :approved, :content_score, :locked, :overview, :tagline, :title, :created_at, :updated_at

if @movie
  if @all
    node(:images) { |movie| movie.images.order("priority ASC") }
    node(:videos) { |movie| movie.videos.order("priority ASC") }
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
    node(:images) { |movie| movie.images.order("images.priority ASC").select {|s| s.approved == true } }
    node(:videos) { |movie| movie.videos.order("videos.priority ASC").select {|s| (s.approved == true && s.link_active == true) } }
    node(:alternative_titles) { |movie| partial("api/v1/alternative_titles/index", :object => movie.alternative_titles.select {|s| s.approved == true } ) }
    node(:crews) { |movie| partial("api/v1/crews/index", :object => movie.crews.select {|s| s.approved == true }) }
    node(:casts) { |movie| partial("api/v1/casts/index", :object => movie.casts.select {|s| s.approved == true }) }
    node(:movie_genres) { |movie| partial("api/v1/movie_genres/index", :object => movie.movie_genres.select {|s| s.approved == true }) }
    node(:movie_keywords) { |movie| partial("api/v1/movie_keywords/index", :object => movie.movie_keywords.select {|s| s.approved == true }) }
    node(:movie_languages) { |movie| partial("api/v1/movie_languages/index", :object => movie.movie_languages.select {|s| s.approved == true }) }
    node(:movie_metadatas) { |movie| partial("api/v1/movie_metadatas/index", :object => movie.movie_metadatas.select {|s| s.approved == true }) }
    node(:revenue_countries) { |movie| partial("api/v1/revenue_countries/index", :object => movie.revenue_countries.select {|s| s.approved == true }) }
    node(:tags) { |movie| partial("api/v1/tags/index", :object => movie.tags.select {|s| s.approved == true } ) }
    node(:production_companies) { |movie| partial("api/v1/production_companies/index", :object => movie.production_companies.select {|s| s.approved == true } ) }
    node(:releases) { |movie| partial("api/v1/releases/index", :object => movie.releases.select {|s| s.approved == true } ) }
  end
  node(:follows) { |movie|
    if @current_api_user
      movie.follows.where(user_id: @current_api_user.id)
    else
      []
    end
  }
  node(:views) { |movie| movie.views.count }
end
