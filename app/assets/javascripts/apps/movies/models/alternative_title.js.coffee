class MoviesApp.AlternativeTitle extends Backbone.Model
  urlRoot: "/api/v1/alternative_titles"
  initialize: (options) ->
    @options = options
