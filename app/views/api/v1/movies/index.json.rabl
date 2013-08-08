object @movies
attributes :id, :approved, :content_score, :locked, :overview, :tagline, :title, :created_at, :updated_at
node(:alternative_titles) { |movie| movie.alternative_titles }
node(:images) { |movie| movie.images }
node(:videos) { |movie| movie.videos }
node(:crews) { |movie| movie.crews }
node(:casts) { |movie| movie.casts }
node(:releases) { |movie| movie.releases }
node(:movie_genres) { |movie| movie.movie_genres }
node(:movie_keywords) { |movie| movie.movie_keywords }
node(:movie_languages) { |movie| movie.movie_languages }
node(:movie_metadatas) { |movie| movie.movie_metadatas }
node(:revenue_countries) { |movie| movie.revenue_countries }
node(:tags) { |movie| movie.tags }
node(:follows) { |movie| movie.follows }
node(:views) { |movie| movie.views }
