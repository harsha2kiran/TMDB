class MoviesApp.Release extends Backbone.Model
  urlRoot: "/api/v1/releases"
  initialize: (options) ->
    @options = options
