class MoviesApp.MovieKeyword extends Backbone.Model
  urlRoot: "/api/v1/movie_keywords"
  initialize: (options) ->
    @options = options
