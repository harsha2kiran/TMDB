class MoviesApp.MovieGenre extends Backbone.Model
  urlRoot: "/api/v1/movie_genres"
  initialize: (options) ->
    @options = options
