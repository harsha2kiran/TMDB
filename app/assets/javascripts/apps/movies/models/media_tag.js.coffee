class MoviesApp.MediaTag extends Backbone.Model
  urlRoot: "/api/v1/media_tags"
  initialize: (options) ->
    @options = options
