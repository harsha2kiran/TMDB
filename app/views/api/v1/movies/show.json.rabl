object @movie
attributes :id, :approved, :content_score, :locked, :overview, :tagline, :title, :created_at, :updated_at
node(:alternative_titles) { |movie| movie.alternative_titles }
node(:images) { |movie| movie.images }
node(:videos) { |movie| movie.videos }
node(:crews) { |movie| movie.crews }
node(:casts) { |movie| movie.casts }
node(:movie_genres) { |movie| movie.movie_genres }
# child(:movie_genres) { attributes :genre }
node(:movie_keywords) { |movie| movie.movie_keywords }
# child(:movie_keywords) { attributes :keyword }
node(:movie_languages) { |movie| movie.movie_languages }
# child(:movie_languages) { attributes :language }
node(:movie_metadatas) { |movie| movie.movie_metadatas }
node(:revenue_countries) { |movie| movie.revenue_countries }
# child(:revenue_countries) { attributes :country }
node(:tags) { |movie| movie.tags }
# child(:tags) { attributes :person }
node(:follows) { |movie| movie.follows }
node(:views) { |movie| movie.views }
node(:releases) { |movie| movie.releases }
node(:production_companies) { |movie| movie.production_companies }
