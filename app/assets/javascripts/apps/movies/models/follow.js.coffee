class MoviesApp.Follow extends Backbone.Model
  urlRoot: "/api/v1/follows"
  initialize: (options) ->
    @options = options
