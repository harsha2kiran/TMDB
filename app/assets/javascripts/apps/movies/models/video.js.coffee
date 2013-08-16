class MoviesApp.Video extends Backbone.Model
  urlRoot: "/api/v1/videos"
  initialize: (options) ->
    @options = options
