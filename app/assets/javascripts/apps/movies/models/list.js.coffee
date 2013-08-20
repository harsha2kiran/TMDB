class MoviesApp.List extends Backbone.Model
  urlRoot: "/api/v1/lists"
  initialize: (options) ->
    @options = options
