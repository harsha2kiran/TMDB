class MoviesApp.MovieMetadata extends Backbone.Model
  urlRoot: "/api/v1/movie_metadatas"
  initialize: (options) ->
    @options = options
