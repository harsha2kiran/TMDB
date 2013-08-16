class MoviesApp.Image extends Backbone.Model
  urlRoot: "/api/v1/images"
  initialize: (options) ->
    @options = options
