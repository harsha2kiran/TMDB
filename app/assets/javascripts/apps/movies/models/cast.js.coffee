class MoviesApp.Cast extends Backbone.Model
  urlRoot: "/api/v1/casts"
  initialize: (options) ->
    @options = options
