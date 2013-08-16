class MoviesApp.MovieLanguage extends Backbone.Model
  urlRoot: "/api/v1/movie_languages"
  initialize: (options) ->
    @options = options
