class MoviesApp.ListKeyword extends Backbone.Model
  urlRoot: "/api/v1/list_keywords"
  initialize: (options) ->
    @options = options
