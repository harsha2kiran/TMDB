class MoviesApp.Tag extends Backbone.Model
  urlRoot: "/api/v1/tags"
  initialize: (options) ->
    @options = options
