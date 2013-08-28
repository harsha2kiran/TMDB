class MoviesApp.Keyword extends Backbone.Model
  urlRoot: "/api/v1/keywords"
  initialize: (options) ->
    @options = options
