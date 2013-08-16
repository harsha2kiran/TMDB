class MoviesApp.Crew extends Backbone.Model
  urlRoot: "/api/v1/crews"
  initialize: (options) ->
    @options = options
