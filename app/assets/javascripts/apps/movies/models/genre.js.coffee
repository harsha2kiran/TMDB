class MoviesApp.Genre extends Backbone.Model
  urlRoot: "/api/v1/genres"
  initialize: (options) ->
    @options = options
