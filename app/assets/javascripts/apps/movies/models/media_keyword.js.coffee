class MoviesApp.MediaKeyword extends Backbone.Model
  urlRoot: "/api/v1/media_keywords"
  initialize: (options) ->
    @options = options
