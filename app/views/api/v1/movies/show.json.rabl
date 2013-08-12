object @movie
attributes :id, :approved, :content_score, :locked, :overview, :tagline, :title, :created_at, :updated_at

if @all
  node(:images) { |movie| movie.images }
  node(:videos) { |movie| movie.videos }

  node(:alternative_titles) { |movie| partial("api/v1/alternative_titles/index", :object => movie.alternative_titles) }
  node(:crews) { |movie| partial("api/v1/crews/index", :object => movie.crews) }
  node(:casts) { |movie| partial("api/v1/casts/index", :object => movie.casts) }
  node(:movie_genres) { |movie| partial("api/v1/movie_genres/index", :object => movie.movie_genres) }
  node(:movie_keywords) { |movie| partial("api/v1/movie_keywords/index", :object => movie.movie_keywords) }
  node(:movie_language) { |movie| partial("api/v1/movie_languages/index", :object => movie.movie_languages) }
  node(:movie_metadatas) { |movie| partial("api/v1/movie_metadatas/index", :object => movie.movie_metadatas) }
  node(:revenue_countries) { |movie| partial("api/v1/revenue_countries/index", :object => movie.revenue_countries) }
  node(:tags) { |movie| partial("api/v1/tags/index", :object => movie.tags ) }
  node(:production_companies) { |movie| partial("api/v1/production_companies/index", :object => movie.production_companies ) }
  node(:releases) { |movie| partial("api/v1/releases/index", :object => movie.releases ) }

else

  node(:images) { |movie| movie.images.where(approved: true) }
  node(:videos) { |movie| movie.videos.where(approved: true) }

  node(:alternative_titles) { |movie| partial("api/v1/alternative_titles/index", :object => movie.alternative_titles.where(approved: true)) }
  node(:crews) { |movie| partial("api/v1/crews/index", :object => movie.crews.where(approved: true)) }
  node(:casts) { |movie| partial("api/v1/casts/index", :object => movie.casts.where(approved: true)) }
  node(:movie_genres) { |movie| partial("api/v1/movie_genres/index", :object => movie.movie_genres.where(approved: true)) }
  node(:movie_keywords) { |movie| partial("api/v1/movie_keywords/index", :object => movie.movie_keywords.where(approved: true)) }
  node(:movie_language) { |movie| partial("api/v1/movie_languages/index", :object => movie.movie_languages.where(approved: true)) }
  node(:movie_metadatas) { |movie| partial("api/v1/movie_metadatas/index", :object => movie.movie_metadatas.where(approved: true)) }
  node(:revenue_countries) { |movie| partial("api/v1/revenue_countries/index", :object => movie.revenue_countries.where(approved: true)) }
  node(:tags) { |movie| partial("api/v1/tags/index", :object => movie.tags.where(approved: true) ) }
  node(:production_companies) { |movie| partial("api/v1/production_companies/index", :object => movie.production_companies.where(approved: true) ) }
  node(:releases) { |movie| partial("api/v1/releases/index", :object => movie.releases.where(approved: true) ) }

end

node(:follows) { |movie| movie.follows }
node(:views) { |movie| movie.views }