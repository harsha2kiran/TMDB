class MoviesApp.Language extends Backbone.Model
  urlRoot: "/api/v1/languages"
  initialize: (options) ->
    @options = options
