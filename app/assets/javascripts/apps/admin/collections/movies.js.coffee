class MoviesApp.Movies extends Backbone.Collection
  model: MoviesApp.Movie
  url: "/api/v1/movies"
