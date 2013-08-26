class MoviesApp.Lock extends Backbone.Model
  urlRoot: "/api/v1/locks"
  initialize: (options) ->
    @options = options
